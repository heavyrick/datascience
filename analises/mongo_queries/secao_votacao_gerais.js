// https://docs.mongodb.com/manual/reference/method/db.collection.find/
// db.getCollection('secao_votacao_gerais').find({"NR_TURNO": "1"}).count()
// db.getCollection('secao_votacao_gerais').find({"NR_TURNO": "1", "CD_CARGO": "6"}).count()

db.getCollection('secao_votacao_gerais').find(
{"NR_TURNO": "1", "CD_CARGO": { "$in": ["6", "7"]}, "NR_VOTAVEL": {"$nin": ["95", "96"]} }, 
{"NR_ZONA": "1", "NR_SECAO": "1", "CD_CARGO": "1", "DS_CARGO": "1", "NR_VOTAVEL": "1", "NR_PARTIDO": "1", "NM_VOTAVEL": "1", "QT_VOTOS": "1"}
)