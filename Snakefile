rule targets:
    input:
        R='code/concat_sensspec.R',
        tsv=expand('results/mothur-{version}_{filetype}/mouse.{header}_header.mod.sensspec',
                version = ['1.37.0', '1.46.1'],
                filetype = ['names', 'count'],
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

rule sensspec_names:
    input:
        sh='code/sensspec_names.sh',
        listfile='data/mouse.{header}_header.list',
        namefile='data/mouse.ng.names',
        distfile='data/mouse.ng.dist'
    output:
        tsv='results/mothur-{version}_names/mouse.{header}_header.sensspec'
    log:
        'log/mouse.{header}_header.mothur-{version}.names.log'
    shell:
        """
        bash {input.sh} {wildcards.version} {input.listfile} {input.namefile} {input.distfile} {log}
        """

rule sensspec_count:
    input:
        sh='code/sensspec_count.sh',
        listfile='data/mouse.{header}_header.list',
        countfile='data/mouse.ng.count_table',
        distfile='data/mouse.ng.dist'
    output:
        tsv='results/mothur-{version}_count/mouse.{header}_header.sensspec'
    log:
        'log/mouse.{header}_header.mothur-{version}.count.log'
#    wildcard_constraints:
#        version='1.46.1'
    shell:
        """
        bash {input.sh} {wildcards.version} {input.listfile} {input.namefile} {input.distfile} {log}
        """

rule mutate_sensspec:
    input:
        R='code/mutate_sensspec.R',
        tsv='results/mothur-{version}_{filetype}/mouse.{header}_header.sensspec'
    output:
        tsv='results/mothur-{version}_{filetype}/mouse.{header}_header.mod.sensspec'
    script:
        'code/mutate_sensspec.R'
