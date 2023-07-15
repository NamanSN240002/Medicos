from api import app
from flask import request
from api.pred import predictDisease, allSymptoms
from api import db
from api.models import User,Diagnosis
from flask_restful import abort,Api, Resource, reqparse
from api.locations import getbusiness_list

# with app.app_context():
#     db.drop_all()
#     db.create_all()

api = Api(app)

register_put_args = reqparse.RequestParser()
register_put_args.add_argument("name",type=str,help="Name is required",required=True)
register_put_args.add_argument("email",type=str,help="email is required",required=True)
register_put_args.add_argument("password1",type=str,help="Password is empty",required=True)
register_put_args.add_argument("password2",type=str,help="Confirm Password is empty",required=True)

login_get_args = reqparse.RequestParser()
login_get_args.add_argument("email",type=str,help="Email is required",required=True)
login_get_args.add_argument("password",type=str,help="Password is required",required=True)

prediction_post_args = reqparse.RequestParser()
prediction_post_args.add_argument("symptoms",type=str,help="Enter Symptoms!",required=True)

doctorlist_post_args = reqparse.RequestParser()
doctorlist_post_args.add_argument("search_string",type=str,help="Enter Search String!",required=True)
doctorlist_post_args.add_argument("location",type=str,help="Enter Location!",required=True)

diagnosis_put_args = reqparse.RequestParser()
diagnosis_put_args.add_argument("userid",type=str,help="Enter user",required=True)
diagnosis_put_args.add_argument("dateTime",type=str,help="Enter Date time",required=True)
diagnosis_put_args.add_argument("diagnosis",type=str,help="Enter Diagnosis",required=True)

diagnosis_post_args = reqparse.RequestParser()
diagnosis_post_args.add_argument("userid",type=str,help="Enter user",required=True)

class Register(Resource):
    def put(self):
        d = {}
        args = register_put_args.parse_args()
        name = args['name']
        email = args['email']
        password1 = args['password1']
        password2 = args['password2']
        if password1!=password2 :
            abort(400,custom="Passowrds don't match!")
        user = User.query.filter_by(email_address=email).first()
        if user:
            abort(400,custom="Email address already in use!")
        user = User(
            name = name,
            email_address = email,
            password= password1
        )
        db.session.add(user)
        db.session.commit()
        d['status'] = True
        d['output'] = {
            'id':str(user.id),
            'name':name,
            'email':email,
            'diagnosis':[]
        }
        return d

class Login(Resource):
    def post(self):
        d = {}
        args = login_get_args.parse_args()
        email = args['email']
        password = args['password']
        user = User.query.filter_by(email_address=email).first()
        if not user:
            abort(500,custom="User not found!")
        if not user.check_password_correction(attempted_password=password):
            abort(500,custom="Incorrect Password!")
        diagnosis = Diagnosis.query.filter_by(user_id=user.id).all()
        dg = []
        for diag in diagnosis:
            dg.append({
             "dateTime":diag.dateTime,
            "diagnosis":diag.diagnosis
            })
        d['output'] = {
            'id':str(user.id),
            'name':user.name,
            'email':user.email_address,
            'diagnosis': dg
            }
        d['status'] = True
        return d
        

class Prediction(Resource):
    def get(self):
        return {'output':list(allSymptoms())}
    
    def post(self):
        args = prediction_post_args.parse_args()
        d = {}
        inputStr = args['symptoms']
        answer = dict(predictDisease(inputStr))
        d['output'] = answer
        return d

class DoctorList(Resource):
    def post(self):
        args = doctorlist_post_args.parse_args()
        locationstr = args['location']
        search_str = args['search_string']
        location = tuple(map(float, locationstr.split(', ')))
        return getbusiness_list(location=location,search_string=search_str)


class AddDiagnosis(Resource):
    def post(self):
        args = diagnosis_post_args.parse_args()
        userid = int(args['userid'])
        diagnosis = Diagnosis.query.filter_by(user_id=userid).all()
        dg = []
        for diag in diagnosis:
            dg.append({
             "dateTime":diag.dateTime,
            "diagnosis":diag.diagnosis
            })
        return {"diagnosis":dg}

    def put(self):
        args = diagnosis_put_args.parse_args()
        userid = int(args['userid'])
        diagnosis = args['diagnosis']
        dateTime = args['dateTime']
        diag = Diagnosis(
            user_id=userid,
            diagnosis=diagnosis,
            dateTime=dateTime
        )
        db.session.add(diag)
        db.session.commit()
        return {"diagnosis":diag.diagnosis,"dateTime":diag.dateTime}


api.add_resource(Prediction,'/prediction')
api.add_resource(DoctorList,'/listDoctors')
api.add_resource(Register,'/register')
api.add_resource(Login,'/login')
api.add_resource(AddDiagnosis,'/diagnosis')