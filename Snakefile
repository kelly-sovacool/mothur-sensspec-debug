datasets = ['miseq_1.0_01', 'mouse']
versions = ['1.37.0', '1.46.1']
filetypes = ['names', 'count_table']
methods = ['vdgc', 'cvsearch']

wildcard_constraints:
    version="|".join(versions),
    filetype="|".join(filetypes)

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
        tsv=expand('results/mothur-{version}_{filetype}/{method}/{dataset}.{method}.tsv',
                    dataset = datasets,
                    version = versions,
                    filetype = filetypes,
                    method = methods
                    )
    output:
        tsv='results/sensspec_concat.tsv'
    script:
        'code/concat_tsv.R'

rule summary:
    input:
        list='data/{dataset}.{method}.list'
    output:
        sum='data/proc/{dataset}.{method}.summary'
    params:
        outdir='data/proc/'
    log:
        'log/summary.single.{dataset}.{method}.log'
    shell:
        """
        mothur "#set.logfile(name={log});
                set.dir(input=data/, output={params.outdir});
                summary.single(list={input.list}, calc=sobs)
                "
        """


rule unique_count:
    input:
        fna='data/{dataset}.fasta'
    output:
        fna='data/proc/{dataset}.unique.fasta',
        names='data/proc/{dataset}.names',
        count_table='data/proc/{dataset}.count_table'
    params:
        outdir='data/proc/'
    log:
        'log/unique_count.{dataset}.log'
    resources:
        procs=16
    shell:
        """
        mothur "#set.logfile(name={log});
                set.dir(input=data/, output={params.outdir});
                unique.seqs(fasta={input.fna});
                count.seqs(name=current)
                "
        """

rule copy_proc_files:
    input:
        c='data/proc/{dataset}.ng.count_table',
        #d='data/proc/{dataset}.ng.unique.dist'
    output:
        c='data/{dataset}.count_table',
        #d='data/{dataset}.dist'
    shell:
        """
        cp {input.c} {output.c}
        """
        #cp {input.d} {output.d}

rule prep_list:
    input:
        count_table='data/{dataset}.count_table',
        list='data/{dataset}.{method}.list',
    output:
        accnos='results/mothur-{version}_count_table/{method}/{dataset}.accnos',
        list='results/mothur-{version}_count_table/{method}/{dataset}.{method}.userLabel.pick.list'
    params:
        outdir='results/mothur-{version}_count_table/{method}/'
    log:
        'log/prep_list.{dataset}.{method}.mothur-{version}_count_table.log'
    shell:
        """
        mothur "#set.logfile(name={log});
                set.dir(input=data/, output={params.outdir});
                list.seqs(count={input.count_table});
                get.seqs(list={input.list}, accnos=current)
                "
        """

rule sensspec_count:
    input:
        list=rules.prep_list.output.list,
        count_table='data/{dataset}.count_table',
        dist='data/{dataset}.unique.dist'
    output:
        tsv='results/mothur-{version}_count_table/{method}/{dataset}.{method}.sensspec'
    params:
        outdir='results/mothur-{version}_count_table/{method}/',
        sensspec='results/mothur-{version}_count_table/{method}/{dataset}.{method}.userLabel.pick.sensspec'
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
                    sens.spec(list={input.list}, count={input.count_table}, column={input.dist}, label=userLabel, cutoff=0.03)
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
