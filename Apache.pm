
=head1 NAME

SML::Apache - apache handler for SML::Document 

=cut

#------------------------------------------------------
# (C) Daniel Peder & Infoset s.r.o., all rights reserved
# http://www.infoset.com, Daniel.Peder@infoset.com
#------------------------------------------------------


###													###
###	size of <TAB> in this document is 4 characters	###
###													###

### //////////////////////////////////////////////////////////////////////////
#
#	SECTION: package
#

	package SML::Apache;


### //////////////////////////////////////////////////////////////////////////
#
#	SECTION: version
#

	use vars qw( $VERSION $VERSION_LABEL $REVISION $REVISION_DATETIME $REVISION_LABEL $PROG_LABEL );

	$VERSION           = '0.10';
	
	$REVISION          = (qw$Revision: 1.2 $)[1];
	$REVISION_DATETIME = join(' ',(qw$Date: 2004/05/23 23:01:26 $)[1,2]);
	$REVISION_LABEL    = '$Id: Apache.pm_rev 1.2 2004/05/23 23:01:26 root Exp root $';
	$VERSION_LABEL     = "$VERSION (rev. $REVISION $REVISION_DATETIME)";
	$PROG_LABEL        = __PACKAGE__." - ver. $VERSION_LABEL";

=pod

 $Revision: 1.2 $
 $Date: 2004/05/23 23:01:26 $

=cut


### //////////////////////////////////////////////////////////////////////////
#
#	SECTION: debug
#

	use vars qw( $DEBUG ); $DEBUG=0;
	

### //////////////////////////////////////////////////////////////////////////
#
#	SECTION: pod intro
#

=head1 SYNOPSIS

 ...apache config 

  <IfModule mod_perl.c>
  ...
    <Files ~ "\.info$">
     SetHandler perl-script
     PerlHandler SML::Apache
     PerlSendHeader On
     Options +ExecCGI
    </Files>
  ...
  </IfModule>
 
 ...apache config
  
=head1 DESCRIPTION

=cut



### //////////////////////////////////////////////////////////////////////////
#
#	SECTION: modules use
#

	require 5.005_62;

	use strict                  ;
	use warnings                ;
	
	use Apache::Constants       qw( :common );
	use Apache::File            ;
	
	use File::Spec              ;
	
	use IO::File::String        ;
	
	use	SML::Document			;
	

### //////////////////////////////////////////////////////////////////////////
#
#	SECTION: methods
#

=head1 METHODS

=over 4

=cut








=item B< handler ($$) >

 $garbage = $CLASS->handler( $apache_request_object )

=cut

### ------------
sub handler ($$)
### ------------
{
	my(		$class, $r		)=@_;
	
	my $self = bless {}, $class;
	
	%{$$self{'args'}} = $r->args;
	
	if( $$self{args}{debug} )
	{
		$self->FastDebugDump( $r );
	}
	else
	{
		my	$filename 		= $r->filename; return NOT_FOUND unless -f $filename; # because we've been catched by location ~.info
		my	$root_dir		= File::Spec->catdir( $r->document_root, ( $ENV{'MAP_DIR'} || '' ) );
		my	$doc			= new SML::Document();
			$doc->base_dir( $root_dir );
			$doc->init_config_file( $filename );

		    $r->content_type("text/html");
		    $r->send_http_header;
	
		    $r->print( $doc->feed_template() );
	}
	
	return OK;
}


=item	FastDebugDump ( )
 
Only for development debuging

=cut

### ---------------------
sub FastDebugDump
### ---------------------
{
	my(		$self, $r		)=@_;
	
	# -- file exists --	
	#
		my $fh = Apache::File->new( $r->filename );
		
	# unless( defined $fh )
	# {
	# 	return NOT_FOUND;
	# }
	
	# -- info file --
	#
	# 	my $InfoFile = DP::InfoDoc::File->new;
	# 
	# $InfoFile->parse( $fh );

    $r->content_type("text/plain");
    $r->send_http_header;
	
    $r->print(join( "\n"
		,'prg.lbl.: '.$PROG_LABEL
		,''
		, Data::Dump::dump( $self->{idoc} )
		,'is_vhost: '.$r->server->is_virtual
		,'doc_root: '.$r->document_root
		,'map_dir.: '.$ENV{'MAP_DIR'}           # virtual root prefix - by apache mod_rewrite
		,'uri.....: '.$r->uri
		,'hostname: '.$r->hostname
		,'filename: '.$r->filename
		,'class...: '.ref($self)
		,''
		,'--self--'
		,Data::Dump::dump( $self )
		,''
		,'--ENV--'
		,Data::Dump::dump( \%ENV )
	));
	
	# $r->send_fd( $fh );

}


1;


### //////////////////////////////////////////////////////////////////////////
#
#	SECTION: pod epilogue
#

=back

=cut

=head1 AUTHOR

 Daniel Peder

 <Daniel.Peder@Infoset.COM>
 http://www.infoset.com

=head1 SEE ALSO

	SML::Parser SML::Document SML::Item SML::Block SML::Builder
	
=cut

__DATA__

__END__

### //////////////////////////////////////////////////////////////////////////
#
#	SECTION: changes log
#

	$Log: Apache.pm_rev $
	Revision 1.2  2004/05/23 23:01:26  root
	changes log started

