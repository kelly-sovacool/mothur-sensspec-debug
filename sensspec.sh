mothur_bin_path=$1
listfile=$2
namefile=$3
distfile=$4

export PATH="${mothur_bin_path}:$PATH"#"bin/mothur-1.37.0/:$PATH"
version=$(mothur -v | grep version | sed 's/^.*=//')
outdir=results/mothur-${version}/

mothur "#set.logfile(name=log/mothur-"${version}".log);
        set.dir(input=data/, output="${outdir}");
        sens.spec(list="${listfile}", name="${namefile}", column="${distfile}", label=userLabel, cutoff=0.03)
        "
