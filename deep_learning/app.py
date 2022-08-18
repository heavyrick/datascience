from config import settings
from flask import Flask, render_template


app = Flask(__name__, template_folder= settings.FRONTEND + 'templates')
app.static_url_path = settings.FRONTEND + 'static'
app.static_folder = settings.FRONTEND + 'static'


@app.route('/')
def index():
    # return "OK!"
    return render_template('index.html', titulo='Teste')


@app.route('/glossario')
def glossario():
    return render_template('glossario.html')


if __name__ == '__main__':
    app.run(debug=settings.DEBUG, port=settings.PORT)
