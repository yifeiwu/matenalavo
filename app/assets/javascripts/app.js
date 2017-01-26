/* global instantsearch */

app({
    appId: 'GTJST8X28Y',
    apiKey: 'c5bc3d7f16951c8154deab0033b6d2fa',
    indexName: 'Post'
});

function app(opts) {
    var search = instantsearch({
        appId: opts.appId,
        apiKey: opts.apiKey,
        indexName: opts.indexName,
        urlSync: true
    });

    search.addWidget(
        instantsearch.widgets.searchBox({
            container: '#search-input',
            placeholder: 'Search here!'
        })
    );

    search.addWidget(
        instantsearch.widgets.hits({
            container: '#hits',
            hitsPerPage: 10,
            templates: {
                item: getTemplate('hit'),
                empty: getTemplate('no-results')
            }
        })
    );

    search.addWidget(
        instantsearch.widgets.stats({
            container: '#stats'
        })
    );

    search.addWidget(
        instantsearch.widgets.pagination({
            container: '#pagination',
            scrollTo: '#search-input'
        })
    );

    search.addWidget(
        instantsearch.widgets.refinementList({
            container: '#category',
            attributeName: 'category',
            sortBy: ['isRefined', 'count:desc', 'category:asc'],
            limit: 10,
            operator: 'or',
            templates: {
                header: getHeader('Category')
            }
        })
    );


    search.start();
}

function getTemplate(templateName) {
    return document.querySelector('#' + templateName + '-template').innerHTML;
}

function getHeader(title) {
    return '<h5>' + title + '</h5>';
}