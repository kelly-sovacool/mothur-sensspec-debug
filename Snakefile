wildcard_constraints:
    filetype="names|count_table"

rule targets:
    input:
        R='code/concat_sensspec.R',
        tsv=expand('results/mothur-{version}_{filetype}/mouse.{header}_header.mod.sensspec',
                version = ['1.37.0', '1.46.1'],
                filetype = ['names', 'count_table'],
                header = ['no', 'with'])
    output:
        tsv='results/sensspec_concat.tsv'
    script:
        'code/concat_sensspec.R'

rule prepend_header:
    input:
        tsv='data/mouse.no_header.list',
        py='code/prepend-header.py'
    output:
        tsv='data/mouse.with_header.list'
    script:
        'code/prepend-header.py'

rule sensspec:
    input:
        tablefile='data/mouse.ng.{filetype}',
        listfile='data/mouse.{header}_header.list',
        distfile='data/mouse.ng.dist'
    output:
        tsv='results/mothur-{version}_{filetype}/mouse.{header}_header.sensspec'
    log:
        'log/mouse.{header}_header.mothur-{version}_{filetype}.log'
    params:
        outdir='results/mothur-{version}_{filetype}/'
    shell:
        """

        if [[ "{wildcards.version}" == "1.37.0" ]]; then
            MOTHUR="bin/mothur-{wildcards.version}/mothur"
        else
            MOTHUR="mothur"
        fi

        avail_version=$($MOTHUR -v | grep version | sed 's/^.*=//')
        if [[ "${{avail_version}}" != "{wildcards.version}" ]]; then
            echo "Error: mothur version requested ({wildcards.version}) is not the same as the one available (${{avail_version}})."
            exit 1
        fi

        if [[ "{wildcards.filetype}" == "names" ]]; then
            $MOTHUR "#set.logfile(name="{log}");
                    set.dir(input=data/, output="{params.outdir}");
                    sens.spec(list="{input.listfile}", name="{input.tablefile}", column="{input.distfile}", label=userLabel, cutoff=0.03)
                    "
        elif [[ "{wildcards.filetype}" == "count_table" ]]; then
            $MOTHUR "#set.logfile(name="{log}");
                    set.dir(input=data/, output="{params.outdir}");
                    sens.spec(list="{input.listfile}", count="{input.tablefile}", column="{input.distfile}", label=userLabel, cutoff=0.03)
                    "
        else
            echo "File type {wildcards.filetype} not recognized. Must be a names or count_table."
            exit 1
        fi
        """

rule mutate_sensspec:
    input:
        R='code/mutate_sensspec.R',
        tsv='results/mothur-{version}_{filetype}/mouse.{header}_header.sensspec'
    output:
        tsv='results/mothur-{version}_{filetype}/mouse.{header}_header.mod.sensspec'
    script:
        'code/mutate_sensspec.R'
