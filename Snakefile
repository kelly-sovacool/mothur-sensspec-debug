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

rule concat_results:
    input:
        R='code/concat_tsv.R',
        tsv=[f'results/mothur-{version}_{filetype}/{method}/{dataset}.{method}.tsv'
            for dataset, version, filetype in zip(
                                            ['miseq_1.0_01', 'mouse', 'mouse'],
                                            ['1.37.0', '1.37.0', '1.46.1'],
                                            ['names', 'names', 'count_table']
                                            )
            for method in ['vdgc', 'cvsearch']
            ]
    output:
        tsv='results/sensspec_concat.tsv'
    script:
        'code/concat_tsv.R'

rule summary:
    input:
        list='data/{dataset}.{method}.list'
    output:
        sum='data/{dataset}.{method}.summary'
    params:
        outdir='data/'
    log:
        'log/summary.single.{dataset}.{method}.log'
    shell:
        """
        mothur "#set.logfile(name={log});
                set.dir(input=data/, output={params.outdir});
                summary.single(list={input.list}, calc=sobs)
                "
        """

rule sensspec_count:
    input:
        count_table='data/{dataset}.count_table',
        list='data/{dataset}.{method}.list',
        dist='data/{dataset}.unique.dist'
    output:
        accnos='results/mothur-{version}_count_table/{method}/{dataset}.accnos',
        list='results/mothur-{version}_count_table/{method}/{dataset}.{method}.userLabel.pick.list',
        tsv='results/mothur-{version}_count_table/{method}/{dataset}.{method}.sensspec'
    params:
        outdir='results/mothur-{version}_count_table/{method}/',
        sensspec='results/mothur-{version}_count_table/{method}/{dataset}.{method}.userLabel.pick.sensspec',
        version='1.46.1'
    log:
        'log/{dataset}.{method}.mothur-{version}_count_table.log'
    shell:
        """
        if [[ "{wildcards.version}" == "1.37.0" ]]; then
            for f in {output}; do
                touch $f;
            done
        else
            mothur "#set.logfile(name={log});
                    set.dir(input=data/, output={params.outdir});
                    list.seqs(count={input.count_table});
                    get.seqs(list={input.list});
                    sens.spec(list=current, count=current, column={input.dist}, label=userLabel, cutoff=0.03)
                    "
            cp {params.sensspec} {output.tsv}
        fi
        """

rule sensspec_names:
    input:
        tablefile='data/{dataset}.names',
        listfile='data/{dataset}.{method}.list',
        distfile='data/{dataset}.unique.dist'
    output:
        tsv='results/mothur-{version}_names/{method}/{dataset}.{method}.sensspec'
    log:
        'log/{dataset}.{method}.mothur-{version}_names.log'
    params:
        outdir='results/mothur-{version}_names/{method}/'
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

        $MOTHUR "#set.logfile(name="{log}");
                set.dir(input=data/, output="{params.outdir}");
                sens.spec(list="{input.listfile}", name="{input.tablefile}", column="{input.distfile}", label=userLabel, cutoff=0.03)
                "
        """

rule mutate_sensspec:
    input:
        R='code/mutate_sensspec.R',
        sensspec='results/mothur-{version}_{filetype}/{method}/{dataset}.{method}.sensspec',
        summary=rules.summary.output.sum
    output:
        tsv='results/mothur-{version}_{filetype}/{method}/{dataset}.{method}.tsv'
    script:
        'code/mutate_sensspec.R'
