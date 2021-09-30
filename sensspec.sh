mothur_bin_path={$1: ?ERROR: provide a path to a mothur binary}
export PATH="$mothur_bin_path:$PATH"#"bin/mothur-1.37.0/:$PATH"
version=$(mothur -v | grep version | sed 's/^.*=//')
outdir=results/mothur-${version}/
listfile=mouse.no_header.list
namefile=mouse.ng.names
distfile=mouse.ng.dist

mkdir -p $outdir
mothur "#set.logfile(name=log/mothur-"${version}".log);
        set.dir(input=data/, output="${outdir}");
        sens.spec(list="${listfile}", name="${namefile}", column="${distfile}", label=userLabel, cutoff=0.03)
        "
