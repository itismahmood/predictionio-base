MYPIO=pio9
docker rm -f ${MYPIO}
docker run -d --hostname=${MYPIO} --restart=always --name=${MYPIO} -p 7079:7070 -p 8000-8010:8000-8010 -v/root/.sbt:/root/.sbt -v/root/.ivy2:/root/.ivy2 --link ssc1:ssc1 itismahmood/predictionio-base
docker exec -it ${MYPIO} bash

jps | cut -d" " -f2 | grep -vi "console" | grep -iv "jps" | sort | paste -sd "," -


cd $ENGINE_HOME/MyRecommendation
curl https://raw.githubusercontent.com/apache/spark/master/data/mllib/sample_movielens_data.txt --create-dirs -o data/sample_movielens_data.txt
python data/import_eventserver.py --access_key $ACCESS_KEY1
pio train
nohup pio deploy --port=8001 &

cd $ENGINE_HOME/MySimilarProduct/
python data/import_eventserver.py --access_key $ACCESS_KEY2
pio train
nohup pio deploy --port=8002 &

cd $ENGINE_HOME/MyECommerceRecommendation/
python data/import_eventserver.py --access_key $ACCESS_KEY3
pio train
nohup pio deploy --port=8003 &



cd $ENGINE_HOME/MyRecommendation
nohup pio deploy --port=8001 &

cd $ENGINE_HOME/MySimilarProduct/
nohup pio deploy --port=8002 &

cd $ENGINE_HOME/MyECommerceRecommendation/
nohup pio deploy --port=8003 &


for i in `seq 1 500`; do  curl -H "Content-Type: application/json" -d '{ "user": "u1", "num": 4, "blackList": ["i21", "i26", "i40"] }' http://localhost:8001/queries.json 2>/dev/null 1>/dev/null ; done
for i in `seq 1 500`; do  curl -H "Content-Type: application/json" -d '{ "user": "u1", "num": 4, "blackList": ["i21", "i26", "i40"] }' http://localhost:8002/queries.json 2>/dev/null 1>/dev/null ; done
for i in `seq 1 500`; do  curl -H "Content-Type: application/json" -d '{ "user": "u1", "num": 4, "blackList": ["i21", "i26", "i40"] }' http://localhost:8003/queries.json 2>/dev/null 1>/dev/null ; done

