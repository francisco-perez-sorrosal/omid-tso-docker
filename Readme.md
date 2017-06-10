# Instructions

1. Create image
```sh
docker build -t omid-tso .
```
2. Run container
```sh
docker run -d --name omid-tso omid-tso
```

Log traces can be found in `/tmp/out.txt` and `/tmp/error.txt`
