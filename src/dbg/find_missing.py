import numpy as np
import sys
from astropy.io import fits

def find_missing(a, b):
    print(f"Finding the missing rows between files {a} and {b}")

    with fits.open(a) as hdul_a:
        with fits.open(b) as hdul_b:
            data_a = hdul_a[1].data
            data_b = hdul_b[1].data
            max_len = max(len(data_a), len(data_b))
            diff_len = max_len - min(len(data_a), len(data_b))
            print(f"Found {diff_len} missing rows out of {max_len}")
            if diff_len == 0: return
            if len(data_a) == max_len:
                data_big = data_a
                data_small = data_b
            else:
                data_big = data_b
                data_small = data_a

            # Get the list of common columns
            columns = []
            for col in hdul_a[1].columns:
                if col not in hdul_b[1].columns: continue
                if type(data_a[col.name][0]) is np.ndarray: continue # Don't compare arrays -- I don't think there's a point
                columns.append(col.name)
            print("Comparing using columns", columns)

            # Iterate through the rows and find common events

            offset_i = 0
            for i in range(max_len):
                if i % 1_000 == 0:
                    print(f"{i}/{max_len}")
                same = True
                for col in columns:
                    if data_big[col][i] != data_small[col][i-offset_i]:
                        print(f"Difference in column {col}: {data_big[col][i]} vs {data_small[col][i-offset_i]}")
                        same = False
                        break
                if not same:
                    print(f"Row ({i}, {i-offset_i}) differed")
                    offset_i += 1

            if offset_i == diff_len:
                print("Success")
            else:
                print(f"Failure because {offset_i} != {diff_len}")


if __name__ == "__main__":
    find_missing(sys.argv[1], sys.argv[2])
