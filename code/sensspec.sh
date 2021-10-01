mothur_version=$1
listfile=$2
namefile=$3
distfile=$4

if [[ "${mothur_version}" == "1.37.0" ]]; then
    export PATH="bin/mothur-${mothur_version}/:$PATH"
fi
version=$(mothur -v | grep version | sed 's/^.*=//')
if [[ "${mothur_version}" != "${version}"]]; then
    echo "Error: mothur version provided (${mothur_version}) is not the same as the one available in the path (${version})."
    exit 1
fi
outdir=results/mothur-${version}/

mothur "#set.logfile(name=log/mothur-"${version}".log);
        set.dir(input=data/, output="${outdir}");
        sens.spec(list="${listfile}", name="${namefile}", column="${distfile}", label=userLabel, cutoff=0.03)
        "
