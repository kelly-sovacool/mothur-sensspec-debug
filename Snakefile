rule render_readme:
    input:
        Rmd='README.Rmd',
        tsv='results/sensspec_concat.tsv'
    output:
        md='README.md'
    shell:
        """
        R -e "rmarkdown::render('{input.Rmd}')"
        """

rule concat_sensspec:
    input:
        R='code/concat_sensspec.R',
        tsv=expand('results/mothur-{version}_{filetype}/{dataset}.{method}.mod.sensspec',
                dataset = ['miseq_1.0_01'],
                version = ['1.37.0', '1.46.1'],
                filetype = ['names'],
                method = ['vdgc', 'cvsearch'])
    output:
        tsv='results/sensspec_concat.tsv'
    script:
        'code/concat_sensspec.R'


rule test_fixes:
    input:
        count_table='data/{dataset}.ng.count_table',
        list='data/{dataset}.{method}.{header}_header.list',
        dist='data/{dataset}.ng.dist'
    output:
        accnos='results/mothur-1.46.1_count_table/{header}_header_TEST/{dataset}.ng.accnos',
        list='results/mothur-1.46.1_count_table/{header}_header_TEST/{dataset}.{header}_header.userLabel.pick.list',
        tsv='results/mothur-1.46.1_count_table/{header}_header_TEST/{dataset}.{header}_header.userLabel.pick.sensspec'
    params:
        outdir='results/mothur-1.46.1_count_table/{header}_header_TEST/'
    log:
        'log/{dataset}.{header}_header.mothur-1.46.1_count_table.TEST.log'
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
        tablefile='data/{dataset}.{filetype}',
        listfile='data/{dataset}.{method}.list',
        distfile='data/{dataset}.unique.dist'
    output:
        tsv='results/mothur-{version}_{filetype}/{dataset}.{method}.sensspec'
    log:
        'log/{dataset}.{method}.mothur-{version}_{filetype}.log'
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
        tsv='results/mothur-{version}_{filetype}/{dataset}.{method}.sensspec'
    output:
        tsv='results/mothur-{version}_{filetype}/{dataset}.{method}.mod.sensspec'
    script:
        'code/mutate_sensspec.R'
