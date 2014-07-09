class OpenSSL;

use OpenSSL::SSL;

has $.ctx;
has $.ssl;
has $.client;

method new(Bool :$client = False, Int :$version?) {
    OpenSSL::SSL::SSL_library_init();

    my $method;
    if $version.defined {
        $method = $version == 2
            ?? ($client ?? OpenSSL::Method::SSLv2_client_method() !! OpenSSL::Method::SSLv2_server_method())
            !! ($client ?? OpenSSL::Method::SSLv3_client_method() !! OpenSSL::Method::SSLv3_server_method());
    }
    else {
        $method = $client ?? OpenSSL::Method::SSLv23_client_method() !! OpenSSL::Method::SSLv23_server_method();
    }
    my $ctx     = OpenSSL::Ctx::SSL_CTX_new( $method );
    my $ssl     = OpenSSL::SSL::SSL_new( $ctx );

    self.bless(:$ctx, :$ssl, :$client);
}
