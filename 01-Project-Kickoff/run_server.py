# run_server.py
import uvicorn

def start():
    uvicorn.run("app.main:app", host="0.0.0.0", port=8001, reload=True)

if __name__ == "__main__":
    start()
