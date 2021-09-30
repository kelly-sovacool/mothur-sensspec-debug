rule prepend_header:
    input:
        tsv='data/mouse.no_header.list',
        py='prepend-header.py'
    output:
        tsv='data/mouse.with_header.list'
    script:
        'prepend-header.py'
