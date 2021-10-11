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

rule test_fixes:
    input:
        count_table='data/mouse.ng.count_table',
        list='data/mouse.{header}_header.list',
        dist='data/mouse.ng.dist'
    output:
        accnos='results/mothur-1.46.1_count_table/{with}_header_TEST/mouse.ng.accnos',
        list='results/mothur-1.46.1_count_table/{header}_header_TEST/mouse.{header}_header.userLabel.pick.list',
        tsv='results/mothur-1.46.1_count_table/{header}_header_TEST/mouse.{header}_header.userLabel.pick.sensspec'
    params:
        outdir='results/mothur-1.46.1_count_table/{header}_header_TEST/'
    log:
        'log/mouse.{header}_header.mothur-1.46.1_count_table.TEST.log'
    wildcard_constraints:
        header='with'
    shell:
        """
        mothur "#set.logfile(name={log});
                set.dir(input=data/, output={params.outdir});
                list.seqs(count={input.count_table});
                get.seqs(list={input.list});
                sens.spec(list=current, count=current, column={input.dist}, label=userLabel, cutoff=0.03)
                "
        """

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
            if [[ "{wildcards.version}" == '1.37.0' ]]; then
                touch {output.tsv} # this version doesn't take a count file
            else
                $MOTHUR "#set.logfile(name="{log}");
                    set.dir(input=data/, output="{params.outdir}");
                    sens.spec(list="{input.listfile}", count="{input.tablefile}", column="{input.distfile}", label=userLabel, cutoff=0.03)
                    "
            fi
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
