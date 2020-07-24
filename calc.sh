#/bin/sh

echo "wake up: start"
curl -s $1 > /dev/null
echo "wake up: done"

echo "bench: start"

function access() {
  resultraw=$(lighthouse $1 --chrome-flags="--headless" --output=json 2>/dev/null) 

  result=$(echo $resultraw | tr -d '[:cntrl:]')

  PerformanceScore=$(echo $result | jq -r '."categories"."performance"."score"')
  FirstContentfulPaint=$(echo $result| jq -r '."audits"."first-contentful-paint"."score"')
  SpeedIndex=$(echo $result| jq -r '."audits"."speed-index"."score"')
  LargestContentfulPaint=$(echo $result| jq -r '."audits"."largest-contentful-paint"."score"')
  TimeToInteractive=$(echo $result| jq -r '."audits"."interactive"."score"')
  TotalBlockingTime=$(echo $result| jq -r '."audits"."total-blocking-time"."score"')
  CumulativeLayoutShift=$(echo $result| jq -r '."audits"."cumulative-layout-shift"."score"')

  score=`echo "$PerformanceScore*100+$FirstContentfulPaint*3+$SpeedIndex*3+$LargestContentfulPaint*5+$TimeToInteractive*3+$TotalBlockingTime*5+$CumulativeLayoutShift"|bc`
  echo $score
}

TopPageScore=`access $1`
echo "TopPage: $TopPageScore"
BlogPageScore=`access $1/b0000`
echo "BlogPage: $BlogPageScore"
EntryPage1Score=`access $1/b0000/entry/e0003`
echo "Entry1: $EntryPage1Score"
EntryPage2Score=`access $1/b0000/entry/e0016`
echo "Entry2: $EntryPage2Score"
NotFoundPageScore=`access $1/b0000/entry/e0100`
echo "NotFound: $NotFoundPageScore"

echo "bench: done"

ScoreSum=`echo "$TopPageScore+$BlogPageScore+$EntryPage1Score+$EntryPage2Score+$NotFoundPageScore"|bc`
echo "Last Score: $ScoreSum"

