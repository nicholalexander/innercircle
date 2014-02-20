$('#coverLink').click(function(e){
            e.preventDefault();
            var childrenElements = HLM.current_article.nextUntil('.credits')
            var target = $(childrenElements[childrenElements.length-1]).offset().top
            var b = $('body,html');
            b.animate({scrollTop: target}, 2000);
        });
