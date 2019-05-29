import os
from sklearn.externals import joblib 
import sys
sys.path.insert(0, 'lib/phoenix_ml/protobuf')

import iris_pb2

def load_model():
    path = os.path.abspath('lib/phoenix_ml/model/classifier.pkl')
    return joblib.load(path)  

def predict_model(args):
    iris_params = iris_pb2.IrisParams()
    iris_params.ParseFromString(args)
    model_params = [[iris_params.sepal_length, iris_params.sepal_width, iris_params.petal_length, iris_params.petal_width]]

    iris_classifier = load_model()
    return iris_classifier.predict(model_params)[0]
