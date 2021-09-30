listfile=$1
namefile=$2
distfile=$3

version=$(mothur -v | grep version | sed 's/^.*=//')
outdir=results/mothur-${version}/

mothur "#set.logfile(name=log/mothur-"${version}".log);
        set.dir(input=data/, output="${outdir}");
        sens.spec(list="${listfile}", name="${namefile}", column="${distfile}", label=userLabel, cutoff=0.03)
        "
