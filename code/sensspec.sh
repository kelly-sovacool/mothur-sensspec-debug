mothur_version=$1
listfile=$2
namefile=$3
distfile=$4

version=$(mothur -v | grep version | sed 's/^.*=//')
outdir=results/mothur-${version}/
logfile=log/mothur-"${version}".$(echo $distfile | sed 's|data/||' | sed 's/\.list//').log


if [[ "${mothur_version}" == "1.37.0" ]]; then
    export PATH="bin/mothur-${mothur_version}/:$PATH"
fi
if [[ "${mothur_version}" != "${version}" ]]; then
    echo "Error: mothur version provided (${mothur_version}) is not the same as the one available in the path (${version})."
    exit 1
fi
mothur "#set.logfile(name="${logfile}");
        set.dir(input=data/, output="${outdir}");
        sens.spec(list="${listfile}", name="${namefile}", column="${distfile}", label=userLabel, cutoff=0.03)
        "
