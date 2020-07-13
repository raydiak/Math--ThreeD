use v6;

class Build {
    method build ($where) {
        chdir $where;
        require($?FILE.IO.parent.child('tools/gen-libs.p6').absolute);
    }
}

# vim: set expandtab:ft=perl6:ts=4:sw=4
