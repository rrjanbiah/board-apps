(function() {
    var $dc = $(document);

    $dc.ready(function() {
        $('body').bind('appPopupAction', insertAppAction);
    });

    function insertAppAction(e) {
        if ($('#r_wp_hardening_modal').find('.modal-footer').length !== 0 && !_.isUndefined(APPS.permission_checked_apps) && APPS.permission_checked_apps.indexOf('r_wp_hardening') !== -1) {
            if ($('#r_wp_hardening_modal .modal-footer').find('#js-WPHardening-btn').length === 0) {
                $('#r_wp_hardening_modal').find('.modal-footer').append('<a href="" id="js-WPHardening-btn" title="' + i18next.t('Import Template') + '" class="btn btn-primary">' + i18next.t('Import Template') + '</a>');
            }
        }
    }

    $dc.on('click', '#js-WPHardening-btn', function(event) {
        $('#r_wp_hardening_modal').modal('hide');
        event.preventDefault();
        $.getJSON("apps/r_wp_hardening/json/app.json", function(data) {
            var formData = new FormData();
            formData.append('board_import', new File([new Blob([JSON.stringify(data)])], 'app.json'));
            $.ajax({
                url: api_url + 'boards.json?token=' + getToken(),
                type: 'POST',
                data: formData,
                processData: false,
                cache: false,
                contentType: false,
                error: function(e, s) {
                    flashMesssage('danger', i18next.t('WordPress Hardenings Board create failed'));
                },
                success: function(response) {
                    if (response.id) {
                        app.navigate('#/board/' + response.id, {
                            trigger: true
                        });
                        flashMesssage('success', i18next.t('WordPress Hardenings Board created'));
                    } else {
                        flashMesssage('danger', i18next.t('Import WordPress Hardenings Board failed'));
                    }
                }
            });
        });
        return false;
    });

    function flashMesssage(type, message) {
        $.bootstrapGrowl(message, {
            type: type,
            offset: {
                from: 'top',
                amount: 20
            },
            align: 'right',
            width: type == 'danger' ? 250 : 400,
            delay: type == 'danger' ? 4000 : 0,
            allow_dismiss: true,
            stackup_spacing: 10
        });
        setTimeout(function() {
            $('.bootstrap-growl').remove();
        }, 4000);
    }

    function getToken() {
        if ($.cookie('auth') !== undefined) {
            var Auth = JSON.parse($.cookie('auth'));
            api_token = Auth.access_token;
            return api_token;
        } else {
            return false;
        }
    }

})();
