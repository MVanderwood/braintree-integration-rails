/* global braintree */
(function() {

    function BTPayment(token) {

        var payment = this;
        braintree.client.create({
            authorization: token
        }, function(clientError, clientInstance) {
            if (clientError) return displayError('client');

            payment.clientInstance = clientInstance;
            createHostedFields();
        });

        function displayError(type) {
            var errors = {
                client: 'error in payment',
                hostedField: 'error in hosted fields',
                token: 'error with token'
            };
            document.getElementById('payment-error').innerHTML = errors[type];
        }

        function createHostedFields() {
            braintree.hostedFields.create({
                client: payment.clientInstance,
                styles: {
                    'input': { 'font-size': '14pt' },
                    'input.invalid': { 'color': 'red' },
                    'input.valid': { 'color': 'green' }
                },
                fields: {
                    number: {
                        selector: '#card-number',
                        placeholder: '4111 1111 1111 1111'
                    },
                    cvv: {
                        selector: '#cvv',
                        placeholder: '123'
                    },
                    expirationDate: {
                        selector: '#expiration-date',
                        placeholder: '10/2019'
                    }
                }
            }, function(hostedFieldError, hostedFieldInstance) {
                window.error = hostedFieldError;
                if (hostedFieldError) return displayError('hostedField');

                document.getElementById('payment-submit').removeAttribute('disabled');

                function submitForm(submitEvent) {
                    submitEvent.preventDefault();
                    hostedFieldInstance.tokenize(function(tokenError, payload) {
                        if (tokenError) return displayError('token');

                        document.getElementsByName('payment-method-nonce')[0].value = payload.nonce;
                        payment.form.submit();
                    });
                }

                payment.form = document.getElementById('payment-form');
                payment.form.addEventListener('submit', submitForm, false);
            });
        }
    }

    window.BTPayment = BTPayment;
})();
