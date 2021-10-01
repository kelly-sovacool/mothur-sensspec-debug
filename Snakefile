rule targets:
    input:
        R='code/concat_sensspec.R',
        tsv=expand('results/mothur-{version}/mouse.{header}_header.mod.sensspec',
                version = ['1.37.0', '1.46.1'],
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
        sh='code/sensspec.sh',
        listfile='data/mouse.{header}_header.list',
        namefile='data/mouse.ng.names',
        distfile='data/mouse.ng.dist'
    output:
        tsv='results/mothur-{version}/mouse.{header}_header.sensspec'
    shell:
        """
        bash {input.sh} {wildcards.version} {input.listfile} {input.namefile} {input.distfile}
        """

rule mutate_sensspec:
    input:
        R='code/mutate_sensspec.R',
        tsv=rules.sensspec.output.tsv
    output:
        tsv='results/mothur-{version}/mouse.{header}_header.mod.sensspec'
    script:
        'code/mutate_sensspec.R'
