#! /usr/bin/perl

$dd = 19;
$mm = 1;
$yy = 14;
@days = ( 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 );

if (open (STATS, "stats.txt") ) {
    while (<STATS>) {
        $stats {$2} = $1 if /data-count="([^"]+)" data-date="([^"]+)"/;
    }
}

$draw =
". = + * + = . . . . . . . = + + + = . . . . = + + + = . . . . = + + + = . . . . . . . . . * * . . . . . ".
"= + * * * + = . . . . . = . . + . . = . . = . . + . . = . . = . . + . . = . . . . . . * * * . . . . . . ".
"+ * * * + . . . . . . . + . * + . * + . . + . * + . * + . . + . * + . * + . . . . . * . * . . . . . . . ".
"* * * . . . . . . . . . + . . + . . + . . + . . + . . + . . + . . + . . + . . . + * + . + . . . . . . . ".
"+ * * * + . . . . . . . + + + + + + + . . + + + + + + + . . + + + + + + + . . . * * * = + = . . . . . . ".
"= + * * * + = . . . . . + + = + + = + . . + + = + + = + . . + + = + + = + . . . + * + = + * . . . . . . ".
". = + * + = . . . . . . + . . + . . + . . + . . + . . + . . + . . + . . + . . . . . . = * + . . . . . . ";
    
$cols = length ($draw) / 14;

for ($col = 0; $col < $cols; $col++) {
    for ($row = 0; $row < 7; $row++) {
        $pixel = substr ($draw, $row * $cols * 2 + $col * 2, 1);
        if ($pixel eq ".") {
            $depth = 1;
        }
        elsif ($pixel eq "=") {
            $depth = 51;
        }
        elsif ($pixel eq "+") {
            $depth = 101;
        }
        elsif ($pixel eq "*") {
            $depth = 151;
        }
        $date = sprintf "20%02d-%02d-%02d", $yy, $mm, $dd;
        $depth -= $stats {$date};
        $depth = 0 if $depth < 0;
        while ($depth > 0) {
            system "git commit -m Beep --allow-empty --quiet --date $date\T12:00";
            $depth--;
        }
        $dd++;
        if ($dd > $days [$mm - 1]) {
            $dd = 1;
            $mm++;
            if ($mm == 13) {
                $mm = 1;
                $yy++;
            }
        }
    }
}
