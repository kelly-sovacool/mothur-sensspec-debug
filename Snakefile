rule targets:
    input:
        expand('results/mothur-{version}/mouse.{header}_header.sensspec',
                version = ['1.37.0', '1.46.1'],
                header = ['no', 'with'])

rule prepend_header:
    input:
        tsv='data/mouse.no_header.list',
        py='prepend-header.py'
    output:
        tsv='data/mouse.with_header.list'
    script:
        'prepend-header.py'

rule sensspec:
    input:
        sh='sensspec.sh',
        listfile='data/mouse.{header}_header.list',
        namefile='data/mouse.ng.names',
        distfile='data/mouse.ng.dist'
    output:
        tsv='results/mothur-{version}/mouse.{header}_header.sensspec'
    shell:
        """
        if [[ "{wildcards.version}" == "1.37.0" ]]; then
            export PATH="bin/mothur-{wildcards.version}/:$PATH"
        fi
        bash {input.sh} {input.listfile} {input.namefile} {input.distfile}
        """