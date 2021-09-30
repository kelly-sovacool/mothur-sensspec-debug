import sys

def main(infilename, outfilename):
    with open(infilename, 'r') as infile:
        line = next(infile)
        list_dat = line.split()
    otus = list_dat[2:]
    num_otus = int(list_dat[1])
    header = ['label', 'numOTUs']
    header += [f'OTU_{i}' for i in range(1, 1 + num_otus)]
    lines = ['\t'.join(line) for line in (header, list_dat)]
    with open(outfilename, 'w') as outfile:
        outfile.write('\n'.join(lines) + '\n')

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])