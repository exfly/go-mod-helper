tmp=$(mktemp -d)

# clean trash
trap "rm -rf $tmp; echo bye; exit" ERR EXIT

UNVER=$tmp/unver.txt
GRAPH=$tmp/graph.dot
RESULT=$tmp/dag.svg

# block: sample
GO111MODULE=on GOPROXY=https://goproxy.cn go mod download

# block: no version
go mod graph | sed -Ee 's/@[^[:blank:]]+//g' | sort | uniq > $UNVER

# block: dot graph
echo "digraph {" > $GRAPH
echo "graph [rankdir=TB, overlap=false];" >> $GRAPH
cat $UNVER  | awk '{print "\""$1"\" -> \""$2"\""};' >> $GRAPH
echo "}" >> $GRAPH
twopi -Tsvg -o $RESULT $GRAPH
echo $RESULT
echo "enter CTRL+C to exit"
sleep 60
