use strict;
use warnings;
use Test::Easy;

use SML::Apache;

TEST 'module use',
CODE {
 return 1;
}
;

RUN;

exit;
__END__
