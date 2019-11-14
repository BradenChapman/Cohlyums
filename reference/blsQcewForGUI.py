
import pymysql, csv, re

def main(args):
    data = getData()
    conn = sqlConnect(args[0:2])
    sqlInsert(data,conn)
    return print(f'\nData Inserted Successfully')
def getData():

    with open('blsCombinedQuarters.csv') as fin:
        infile, df = csv.reader(fin, delimiter = ','), []
        count = 0
        for i in infile:
            if count == 0:
                count += 1
            elif count != 0:
                df.append((int(i[0]),int(i[2]),str(i[3]),int(i[4]),int(i[6]), \
                    int(i[7]),str(i[8]),int(i[9]),int(i[10]),int(i[11]),\
                    int(i[12]),str(i[13]),int(i[16])))
    with open('blsCombinedAnnuals.csv') as fin:
        infile, odf = csv.reader(fin,delimiter = ','), []
        count = 0
        for i in infile:
            if count == 0:
                count +=1
            elif count != 0:
                odf.append([int(i[0]),int(i[2]),str(i[3]),int(i[4]),int(i[6]),\
                    str(i[8]),int(i[9]),int(i[10]),int(i[14]),int(i[15])])
    with open('ownership_titles.csv') as fin:
        infile, own_titles = csv.reader(fin,delimiter = ','), []
        count = 0
        for i in infile:
            if count == 0:
                count +=1
            elif count != 0:
                own_titles.append([int(i[0]),str(i[1])])
    with open('industry_titles.csv') as fin:
        infile, industry_titles = csv.reader(fin,delimiter = ','), []
        count = 0
        for i in infile:
            if count == 0:
                count +=1
            elif count != 0:
                industry_titles.append([str(i[0]),re.sub(r'(NAICS)? ?\d{1,7} ','',i[1])])
    with open('agglevel_titles.csv') as fin:
        infile, agglvl_titles = csv.reader(fin,delimiter = ','), []
        count = 0
        for i in infile:
            if count == 0:
                count +=1
            elif count != 0:
                agglvl_titles.append([int(i[0]),str(i[1])])
    return [df, odf, own_titles, industry_titles, agglvl_titles]
def sqlConnect(args):
    global connection
    connection = None
    try:
        connection = pymysql.connect(host= 'localhost',
                                     user=args[0],
                                     password=args[1],
                                     db= 'blsQcew',
                                     charset='utf8mb4',
                                     cursorclass=pymysql.cursors.DictCursor)
    except Exception as e:
        print(f"Couldn't log {args[0]} in to MySQL server")
        print(e)
    return connection

def sqlInsert(data, conn):
    cur = conn.cursor()
    query = 'INSERT INTO combined_quarters VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)'
    cur.executemany(query, data[0])
    query = 'INSERT INTO combined_annuals VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)'
    cur.executemany(query, data[1])
    query = 'INSERT INTO own_titles VALUES (%s,%s)'
    cur.executemany(query, data[2])
    query = 'INSERT INTO  industry_titles VALUES (%s,%s)'
    cur.executemany(query, data[3])
    query = 'INSERT INTO agglvl_titles VALUES (%s,%s)'
    cur.executemany(query, data[4])
    conn.commit()
    return None
if __name__ == '__main__':
    import sys
    main(["root","asdf"])
