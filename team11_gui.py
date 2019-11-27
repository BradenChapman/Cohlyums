import pymysql, sys
from typing import *
from PyQt5.QtCore import Qt, QAbstractTableModel, QVariant
from PyQt5.QtGui import QPixmap
from PyQt5.QtWidgets import (
    QApplication,
    QPushButton,
    QDialog,
    QGroupBox,
    QComboBox,
    QMessageBox,
    QVBoxLayout,
    QHBoxLayout,
    QDialogButtonBox,
    QFormLayout,
    QLineEdit,
    QTableView,
    QAbstractItemView,
    QLabel,
    qApp
)

# MEMORABLE COMMENTS
#
#    - "It's the fix a ton of stuff that destroyed everthing" - David Zhou
#    - "I can assure that the rest of the SP work .... 5:15 pm" - David Zhou
#    - "Wait ... this actually makes no sense ..." - David Zhou

# STATIC FUNCTIONS
def getCompanyNames():
    curs.execute("SELECT DISTINCT comname FROM company;")
    dum = curs.fetchall()
    return [ i["comname"] for i in dum]

def getCreditCards(un):
    curs.execute(f'SELECT creditcardnum FROM customercreditcard where username = "{un}";')
    return [i["creditcardnum"] for i in curs.fetchall()]

def getManagerNames():
    curs.execute("SELECT username FROM manager;")
    return [i["username"] for i in curs.fetchall()]

def getUserNameMapping():
    curs.execute("SELECT username, firstname, lastname FROM user;")
    return {i["username"] : f'{i["firstname"]} {i["lastname"]}' for i in curs.fetchall()}

def getMinAndMaxDate():
    curs.execute("SELECT min(visitdate) as min1 from uservisittheater;")
    dum1 = curs.fetchall()
    curs.execute("SELECT max(visitdate) as max1 from uservisittheater;")
    dum2 = curs.fetchall()
    return [i["min1"] for i in dum1] + [i["max1"] for i in dum2]

def getMinAndMaxDateMoviePlay():
    curs.execute("SELECT min(movPlayDate) as min1 from movieplay;")
    dum1 = curs.fetchall()
    curs.execute("SELECT max(movPlayDate) as max1 from movieplay;")
    dum2 = curs.fetchall()
    return [i["min1"] for i in dum1] + [i["max1"] for i in dum2]

def getMovies():
    curs.execute("SELECT movname from movie;")
    return [i["movname"] for i in curs.fetchall()]

def getStates():
    curs.execute("SELECT DISTINCT thState from theater;")
    return [ i["thState"] for i in curs.fetchall() ]

def getManagersAtCompany(comp):
    curs.execute(f"SELECT username FROM manager where comname = '{comp}';")
    return [i["username"] for i in curs.fetchall()]

def isDuplicateUsername(un):
    dum = curs.execute(f'SELECT DISTINCT username FROM user where username = "{un}";')
    if dum:
        w = QMessageBox()
        QMessageBox.warning(w, "Registration Error", "Your username is already in use")
        return True
    else:
        return False

def isDuplicateCreditCard(ccNum):
    dum = curs.execute(f'SELECT DISTINCT creditCardNum FROM customercreditcard where creditCardNum = "{ccNum}";')
    if dum:
        print('ok this is right')
        w = QMessageBox()
        QMessageBox.warning(w, "Duplicate Error", "Your credit card number is already in use")
        return True
    else:
        return False

def addCreditCards(un, ccComboBox, storedProc):
    allItems = [ccComboBox.itemText(i) for i in range(ccComboBox.count())]
    if len(allItems) > 5:
        w = QMessageBox()
        QMessageBox.warning(w, "Capacity Error", "You have input too many credit cards. Please input 5 or less credit cards.")
        return "error"
    else:
        # creditCard: IN i_username VARCHAR(50), IN i_creditCardNum CHAR(16)
        # error = False
        for i in range(len(allItems)):
            if not len(allItems[i]) == 16:
                b = QMessageBox()
                QMessageBox.warning(b, "Length Error", "One of your credit cards is not of length 16")
                # error = True
                return "error"
            elif isDuplicateCreditCard(allItems[i]):
                # error = True
                return "error"
        for j in range(len(allItems)):
            curs.execute(f'call {storedProc}("{un}", "{allItems[j]}");')

def removeUser(un):
    user = curs.execute(f'SELECT DISTINCT username FROM user where username = "{un}";')
    admin = curs.execute(f'SELECT DISTINCT username FROM admin where username = "{un}";')
    customer = curs.execute(f'SELECT DISTINCT username FROM customer where username = "{un}";')
    manager = curs.execute(f'SELECT DISTINCT username FROM manager where username = "{un}";')
    employee = curs.execute(f'SELECT DISTINCT username FROM employee where username = "{un}";')

    if admin:
        curs.execute(f'DELETE FROM admin WHERE username = "{un}";')
    if customer:
        curs.execute(f'DELETE FROM customer WHERE username = "{un}";')
    if manager:
        curs.execute(f'DELETE FROM manager WHERE username = "{un}";')
    if employee:
        curs.execute(f'DELETE FROM employee WHERE username = "{un}";')
    if user:
        curs.execute(f'DELETE FROM user WHERE username = "{un}";')

    connection.commit()

# Helper class for tables
class SimpleTableModel(QAbstractTableModel):
    def __init__(self, data: List[Dict[str, str]]):
        QAbstractTableModel.__init__(self, None)
        self.data = data
        self.headers = [str(k) for k, v in data[0].items()]
        self.rows = [[str(v) for k, v in record.items()] for record in data]

    def rowCount(self, parent):
        return len(self.rows)

    def columnCount(self, parent):
        return len(self.headers)

    def data(self, index, role):
        if (not index.isValid()) or (role != Qt.DisplayRole):
            return QVariant()
        else:
            return QVariant(self.rows[index.row()][index.column()])

    def row(self, index):
        return self.data[index]

    def headerData(self, section, orientation, role):
        if role != Qt.DisplayRole:
            return QVariant()
        elif orientation == Qt.Vertical:
            return section + 1
        else:
            return self.headers[section]

# DONEish
#     - Hide password
class Login(QDialog):
    def __init__(self):
        super(Login, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Atlanta Movie Login")

        self.username = QLineEdit()
        self.password = QLineEdit()

        form_group_box = QGroupBox("Enter your login credentials")
        layout = QFormLayout()
        layout.addRow(QLabel("Username:"), self.username)
        layout.addRow(QLabel("Password:"), self.password)
        form_group_box.setLayout(layout)

        self.login = QPushButton("Login")
        self.login.pressed.connect(self.run_login)
        self.register = QPushButton("Register")
        self.register.pressed.connect(self.run_register)

        hbox = QHBoxLayout()
        hbox.addWidget(self.login)
        hbox.addWidget(self.register)

        vbox_layout = QVBoxLayout()
        vbox_layout.addWidget(form_group_box)
        vbox_layout.addLayout(hbox)
        self.setLayout(vbox_layout)
        self.username.setFocus()

    def run_login(self):
        un = self.username.text()
        p = self.password.text()
        # un = "calcultron"
        # p = "333333333"

        if un:
            if not p:
                if un == "a":
                    un = "cool_class4400"
                    p = "333333333"
                elif un == "ac":
                    un = "cool_class4400"
                    p = "333333333"
                elif un == "m":
                    un = "fatherai"
                    p = "222222222"
                elif un == "mc":
                    un = "georgep"
                    p = "111111111"
                elif un == "c":
                    un = "fullmetal"
                    p = "111111100"
                elif un == "u":
                    un = "gdanger"
                    p = "555555555"


        # SET GLOBAL VARIABLE USERNAME
        global USERNAME
        USERNAME = un

        curs.execute(f'call user_login("{un}", "{p}");')
        curs.fetchall()
        curs.execute('SELECT * FROM UserLogin;')
        a = curs.fetchall()
        if bool(a):
            a = a[0]
            status, ic, ia, im = a["status"], int(a["isCustomer"]), int(a["isAdmin"]), int(a["isManager"])
            if ia:
                if ic:
                    self.close()
                    AdminCustomer().exec()
                else:
                    self.close()
                    AdminOnly().exec()

            elif im:
                if ic:
                    self.close()
                    ManagerCustomer().exec()
                else:
                    self.close()
                    ManagerOnly().exec()

            elif ic:
                self.close()
                Customer().exec()

            else:
                self.close()
                User().exec()
        else:
            w = QMessageBox()
            QMessageBox.warning(w, "Login Error", "Your login credentials are not valid, please try again or register")
            w.show()

    def run_register(self):
        self.close()
        RegisterNavigation().exec()

# DOOONNNEE
class RegisterNavigation(QDialog):

    def __init__(self):
        super(RegisterNavigation, self).__init__()
        print("RegisterNavigation")
        self.setModal(True)
        self.setWindowTitle("Register Navigation")

        self.uo = QPushButton("User Only")
        self.uo.pressed.connect(self.uo_)
        self.co = QPushButton("Customer Only")
        self.co.pressed.connect(self.co_)
        self.mo = QPushButton("Manager Only")
        self.mo.pressed.connect(self.mo_)
        self.mc = QPushButton("Manager Customer")
        self.mc.pressed.connect(self.mc_)
        self.b = QPushButton("Back")
        self.b.pressed.connect(self.back)

        self.vbox = QVBoxLayout()
        self.vbox.addWidget(self.uo)
        self.vbox.addWidget(self.co)
        self.vbox.addWidget(self.mo)
        self.vbox.addWidget(self.mc)
        self.vbox.addWidget(self.b)

        self.setLayout(self.vbox)

    def uo_(self):
        self.close()
        UserRegistration().exec()

    def co_(self):
        self.close()
        CustomerRegistration().exec()

    def mo_(self):
        self.close()
        ManagerRegistration().exec()

    def mc_(self):
        self.close()
        ManagerCustomerRegistration().exec()

    def back(self):
        self.close()
        Login().exec()

# DONEish
#     - Hide password, password len
class UserRegistration(QDialog):

    def __init__(self):
        super(UserRegistration, self).__init__()
        self.setModal(True)
        self.setWindowTitle("User Registration")

        self.firstname = QLineEdit()
        self.lastname = QLineEdit()
        self.username = QLineEdit()
        self.password = QLineEdit()
        self.cpassword = QLineEdit()

        form_group_box = QGroupBox("Please fill out the form below.")
        layout = QFormLayout()
        main_hb = QHBoxLayout()

        vb1 = QVBoxLayout()
        vb1.addWidget(QLabel("First Name:"))
        vb1.addWidget(self.firstname)
        vb1.addWidget(QLabel("User Name:"))
        vb1.addWidget(self.username)
        vb1.addWidget(QLabel("Password:"))
        vb1.addWidget(self.password)
        main_hb.addLayout(vb1)

        vb2 = QVBoxLayout()
        vb2.addWidget(QLabel("Last Name:"))
        vb2.addWidget(self.lastname)
        vb2.addWidget(QLabel(""))
        vb2.addWidget(QLabel(""))
        vb2.addWidget(QLabel("Confirm Password:"))
        vb2.addWidget(self.cpassword)
        main_hb.addLayout(vb2)

        form_group_box.setLayout(main_hb)

        self.back = QPushButton("Back")
        self.back.pressed.connect(self.run_back)
        self.register = QPushButton("Register")
        self.register.pressed.connect(self.run_register)

        hbox = QVBoxLayout()
        hbox.addWidget(self.back)
        hbox.addWidget(self.register)

        vbox_layout = QVBoxLayout()
        vbox_layout.addWidget(form_group_box)
        vbox_layout.addLayout(hbox)
        self.setLayout(vbox_layout)
        self.username.setFocus()

    def run_back(self):
        self.close()
        RegisterNavigation().exec()

    def run_register(self):
        # TEST FOR PASSWORD COMPATIBILITY, USERNAME TAKEN, ETC...
        firstName = self.firstname.text()
        lastName = self.lastname.text()
        username = self.username.text()
        password = self.password.text()
        cPassword = self.cpassword.text()
        if not isDuplicateUsername(username):
            if not firstName == "" and not lastName == "" and not username == "" and not password == "":
                if cPassword == password:
                    curs.execute(f'call user_register("{username}", "{password}", "{firstName}", "{lastName}");')
                    self.close()
                    connection.commit()
                    Login().exec()
                else:
                    w = QMessageBox()
                    QMessageBox.warning(w, "Registration Error", "Your passwords do not match")
            else:
                b = QMessageBox()
                QMessageBox.warning(b, "Registration Error", "You are missing some input")

# DONEish
# - Hide password, password len, no more than 5 credit cards
class CustomerRegistration(QDialog):

    def __init__(self):
        super(CustomerRegistration, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Customer Registration")

        self.firstname = QLineEdit()
        self.lastname = QLineEdit()
        self.username = QLineEdit()
        self.password = QLineEdit()
        self.cpassword = QLineEdit()

        form_group_box = QGroupBox("Please fill out the form below.")
        layout = QFormLayout()
        main_vb = QVBoxLayout()
        main_hb = QHBoxLayout()

        vb1 = QVBoxLayout()
        vb1.addWidget(QLabel("First Name:"))
        vb1.addWidget(self.firstname)
        vb1.addWidget(QLabel("User Name:"))
        vb1.addWidget(self.username)
        vb1.addWidget(QLabel("Password:"))
        vb1.addWidget(self.password)
        main_hb.addLayout(vb1)

        vb2 = QVBoxLayout()
        vb2.addWidget(QLabel("Last Name:"))
        vb2.addWidget(self.lastname)
        vb2.addWidget(QLabel(""))
        vb2.addWidget(QLabel(""))
        vb2.addWidget(QLabel("Confirm Password:"))
        vb2.addWidget(self.cpassword)
        main_hb.addLayout(vb2)

        main_vb.addLayout(main_hb)

        form_group_box.setLayout(main_vb)

        card_box = QHBoxLayout()
        card_box.addWidget(QLabel("Credit Card #:"))

        self.cards = QVBoxLayout()
        self.hbox1 = QHBoxLayout()
        self.hbox2 = QHBoxLayout()

        self.card_num = QLineEdit()
        add = QPushButton("Add")
        add.pressed.connect(self.add_)
        self.hbox1.addWidget(self.card_num)
        self.hbox1.addWidget(add)

        self.card_cb = QComboBox()
        remove = QPushButton("Remove")
        remove.pressed.connect(self.remove_)
        self.hbox2.addWidget(self.card_cb)
        self.hbox2.addWidget(remove)

        self.cards.addLayout(self.hbox1)
        self.cards.addLayout(self.hbox2)
        card_box.addLayout(self.cards)

        self.back = QPushButton("Back")
        self.back.pressed.connect(self.run_back)
        self.register = QPushButton("Register")
        self.register.pressed.connect(self.run_register)

        hbox = QVBoxLayout()
        hbox.addLayout(card_box)
        hbox.addWidget(self.back)
        hbox.addWidget(self.register)

        vbox_layout = QVBoxLayout()
        vbox_layout.addWidget(form_group_box)
        vbox_layout.addLayout(hbox)
        self.setLayout(vbox_layout)
        self.username.setFocus()

    def run_back(self):
        self.close()
        RegisterNavigation().exec()

    def run_register(self):
        # TEST FOR PASSWORD COMPATIBILITY, USERNAME TAKEN, ETC...

        firstName = self.firstname.text()
        lastName = self.lastname.text()
        username = self.username.text()
        password = self.password.text()
        cPassword = self.cpassword.text()

        if not isDuplicateUsername(username):
            if not firstName == "" and not lastName == "" and not username == "" and not password == "":
                if cPassword == password:
                    curs.execute(f'call customer_only_register("{username}", "{password}", "{firstName}", "{lastName}");')
                    error = addCreditCards(username, self.card_cb, "customer_add_creditcard")
                    if error != "error":
                        self.close()
                        connection.commit()
                        Login().exec()
                    else:
                        removeUser(username)
                else:
                    w = QMessageBox()
                    QMessageBox.warning(w, "Registration Error", "Your passwords do not match")
            else:
                m = QMessageBox()
                QMessageBox.warning(m, "Registration Error", "You are missing some input")
        else:
            x = QMessageBox()
            QMessageBox.warning(x, "Registration Error", "Username already taken.")

    def add_(self):
        self.card_cb.addItems([self.card_num.text()])
        self.card_num.setText("")

    def remove_(self):
        i = self.card_cb.currentIndex()
        self.card_cb.removeItem(i)

# DONEish
#   - Hide password, password len
class ManagerRegistration(QDialog):

    def __init__(self):
        super(ManagerRegistration, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Manager Registration")

        self.firstname = QLineEdit()
        self.lastname = QLineEdit()
        self.username = QLineEdit()
        self.company = QComboBox()
        self.company.addItems(getCompanyNames())
        self.password = QLineEdit()
        self.cpassword = QLineEdit()
        self.address = QLineEdit()
        self.city = QLineEdit()
        self.state = QComboBox()
        self.state.addItems(getStates())
        self.zip = QLineEdit()

        form_group_box = QGroupBox("Please fill out the form below.")
        layout = QFormLayout()
        main_vb = QVBoxLayout()
        main_hb = QHBoxLayout()

        vb1 = QVBoxLayout()
        vb1.addWidget(QLabel("First Name:"))
        vb1.addWidget(self.firstname)
        vb1.addWidget(QLabel("User Name:"))
        vb1.addWidget(self.username)
        vb1.addWidget(QLabel("Password:"))
        vb1.addWidget(self.password)
        main_hb.addLayout(vb1)

        vb2 = QVBoxLayout()
        vb2.addWidget(QLabel("Last Name:"))
        vb2.addWidget(self.lastname)
        vb2.addWidget(QLabel("Company"))
        vb2.addWidget(self.company)
        vb2.addWidget(QLabel("Confirm Password:"))
        vb2.addWidget(self.cpassword)
        main_hb.addLayout(vb2)

        main_vb.addLayout(main_hb)

        ovb = QVBoxLayout()
        ovb.addWidget(QLabel("Street Address:"))
        ovb.addWidget(self.address)

        main_vb.addLayout(ovb)

        ohb = QHBoxLayout()
        ovb = QVBoxLayout()
        ovb.addWidget(QLabel("City:"))
        ovb.addWidget(self.city)
        ohb.addLayout(ovb)
        oovb = QVBoxLayout()
        oovb.addWidget(QLabel("State:"))
        oovb.addWidget(self.state)
        ohb.addLayout(oovb)
        ooovb = QVBoxLayout()
        ooovb.addWidget(QLabel("Zipcode:"))
        ooovb.addWidget(self.zip)
        ohb.addLayout(ooovb)

        main_vb.addLayout(ohb)

        form_group_box.setLayout(main_vb)

        self.back = QPushButton("Back")
        self.back.pressed.connect(self.run_back)
        self.register = QPushButton("Register")
        self.register.pressed.connect(self.run_register)

        hbox = QVBoxLayout()
        hbox.addWidget(self.back)
        hbox.addWidget(self.register)

        vbox_layout = QVBoxLayout()
        vbox_layout.addWidget(form_group_box)
        vbox_layout.addLayout(hbox)
        self.setLayout(vbox_layout)
        self.username.setFocus()

    def run_back(self):
        self.close()
        RegisterNavigation().exec()

    def run_register(self):
        # TEST FOR PASSWORD COMPATIBILITY, USERNAME TAKEN, ETC...
        firstName = self.firstname.text()
        lastName = self.lastname.text()
        username = self.username.text()
        company = self.company.currentText()
        password = self.password.text()
        cPassword = self.cpassword.text()
        address = self.address.text()
        city = self.city.text()
        state = self.state.currentText()
        zipcode = self.zip.text()

        # IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50),
        # IN i_comName VARCHAR(50), IN i_empStreet VARCHAR(50), IN i_empCity VARCHAR(50), IN i_empState CHAR(2), IN i_empZipcode CHAR(5))
        if not isDuplicateUsername(username):
            if not firstName == "" and not lastName == "" and not username == "" and not password == "" and not company == "" and not address == "" and not city == "" and not state == "" and not zipcode == "":
                if cPassword == password:
                    if len(zipcode) == 5:
                        curs.execute(f'call manager_only_register("{username}", "{password}", "{firstName}", "{lastName}", "{company}", "{address}", "{city}", "{state}", "{zipcode}");')
                        self.close()
                        connection.commit()
                        Login().exec()
                    else:
                        w = QMessageBox()
                        QMessageBox.warning(w, "Registration Error", "Your zipcode is not 5 characters")
                else:
                    w = QMessageBox()
                    QMessageBox.warning(w, "Registration Error", "Your passwords do not match")
            else:
                b = QMessageBox()
                QMessageBox.warning(b, "Registration Error", "You are missing some input")

# Doneish
#    - Hide password, password len
class ManagerCustomerRegistration(QDialog):
    def __init__(self):
        super(ManagerCustomerRegistration, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Manager Customer Registration")

        self.firstname = QLineEdit()
        self.lastname = QLineEdit()
        self.username = QLineEdit()
        self.company = QComboBox()
        self.company.addItems(getCompanyNames())
        self.password = QLineEdit()
        self.cpassword = QLineEdit()
        self.address = QLineEdit()
        self.city = QLineEdit()
        self.state = QComboBox()
        self.state.addItems(getStates())
        self.zip = QLineEdit()

        form_group_box = QGroupBox("Please fill out the form below.")
        layout = QFormLayout()
        main_vb = QVBoxLayout()
        main_hb = QHBoxLayout()

        vb1 = QVBoxLayout()
        vb1.addWidget(QLabel("First Name:"))
        vb1.addWidget(self.firstname)
        vb1.addWidget(QLabel("User Name:"))
        vb1.addWidget(self.username)
        vb1.addWidget(QLabel("Password:"))
        vb1.addWidget(self.password)
        main_hb.addLayout(vb1)

        vb2 = QVBoxLayout()
        vb2.addWidget(QLabel("Last Name:"))
        vb2.addWidget(self.lastname)
        vb2.addWidget(QLabel("Company"))
        vb2.addWidget(self.company)
        vb2.addWidget(QLabel("Confirm Password:"))
        vb2.addWidget(self.cpassword)
        main_hb.addLayout(vb2)

        main_vb.addLayout(main_hb)

        ovb = QVBoxLayout()
        ovb.addWidget(QLabel("Street Address:"))
        ovb.addWidget(self.address)

        main_vb.addLayout(ovb)

        ohb = QHBoxLayout()
        ovb = QVBoxLayout()
        ovb.addWidget(QLabel("City:"))
        ovb.addWidget(self.city)
        ohb.addLayout(ovb)
        oovb = QVBoxLayout()
        oovb.addWidget(QLabel("State:"))
        oovb.addWidget(self.state)
        ohb.addLayout(oovb)
        ooovb = QVBoxLayout()
        ooovb.addWidget(QLabel("Zipcode:"))
        ooovb.addWidget(self.zip)
        ohb.addLayout(ooovb)

        main_vb.addLayout(ohb)

        form_group_box.setLayout(main_vb)

        card_box = QHBoxLayout()
        card_box.addWidget(QLabel("Credit Card #:"))

        self.cards = QVBoxLayout()
        self.hbox1 = QHBoxLayout()
        self.hbox2 = QHBoxLayout()

        self.card_num = QLineEdit()
        add = QPushButton("Add")
        add.pressed.connect(self.add_)
        self.hbox1.addWidget(self.card_num)
        self.hbox1.addWidget(add)

        self.card_cb = QComboBox()
        remove = QPushButton("Remove")
        remove.pressed.connect(self.remove_)
        self.hbox2.addWidget(self.card_cb)
        self.hbox2.addWidget(remove)

        self.cards.addLayout(self.hbox1)
        self.cards.addLayout(self.hbox2)
        card_box.addLayout(self.cards)

        self.back = QPushButton("Back")
        self.back.pressed.connect(self.run_back)
        self.register = QPushButton("Register")
        self.register.pressed.connect(self.run_register)

        hbox = QVBoxLayout()
        hbox.addLayout(card_box)
        hbox.addWidget(self.back)
        hbox.addWidget(self.register)

        vbox_layout = QVBoxLayout()
        vbox_layout.addWidget(form_group_box)
        vbox_layout.addLayout(hbox)
        self.setLayout(vbox_layout)
        self.username.setFocus()

    def run_back(self):
        self.close()
        RegisterNavigation().exec()

    def run_register(self):
        # TEST FOR PASSWORD COMPATIBILITY, USERNAME TAKEN, ETC...
        firstName = self.firstname.text()
        lastName = self.lastname.text()
        username = self.username.text()
        company = self.company.currentText()
        password = self.password.text()
        cPassword = self.cpassword.text()
        address = self.address.text()
        city = self.city.text()
        state = self.state.currentText()
        zipcode = self.zip.text()

        if not isDuplicateUsername(username):
            if not firstName == "" and not lastName == "" and not username == "" and not password == "" and not company == "" and not address == "" and not city == "" and not state == "" and not zipcode == "":
                if cPassword == password:
                    if len(zipcode) == 5:
                        curs.execute(f'call manager_customer_register("{username}", "{password}", "{firstName}", "{lastName}", "{company}", "{address}", "{city}", "{state}", "{zipcode}");')
                        error = addCreditCards(username, self.card_cb, "manager_customer_add_creditcard")
                        if error != "error":
                            self.close()
                            connection.commit()
                            Login().exec()
                        else:
                            print('error')
                            removeUser(username)
                    else:
                        w = QMessageBox()
                        QMessageBox.warning(w, "Registration Error", "Your zipcode is not 5 characters")
                else:
                    w = QMessageBox()
                    QMessageBox.warning(w, "Registration Error", "Your passwords do not match")
            else:
                m = QMessageBox()
                QMessageBox.warning(m, "Registration Error", "You are missing some input")
        else:
            x = QMessageBox()
            QMessageBox.warning(x, "Registration Error", "Username already taken.")

        # self.close()
        # Login().exec()

    def add_(self):
        self.card_cb.addItems([self.card_num.text()])
        self.card_num.setText("")

    def remove_(self):
        i = self.card_cb.currentIndex()
        self.card_cb.removeItem(i)

# DONE
class AdminOnly(QDialog):

    def __init__(self):
        super(AdminOnly, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Admin-Only Functionality")

        self.mhbox = QHBoxLayout()

        self.vbox1 = QVBoxLayout()
        self.mu = QPushButton("Manager User")
        self.mu.pressed.connect(self.mu_)
        self.mc = QPushButton("Manage Company")
        self.mc.pressed.connect(self.mc_)
        self.cm = QPushButton("Create Movie")
        self.cm.pressed.connect(self.cm_)
        self.vbox1.addWidget(self.mu)
        self.vbox1.addWidget(self.mc)
        self.vbox1.addWidget(self.cm)

        self.vbox2 = QVBoxLayout()
        self.et = QPushButton("Explore Theater")
        self.et.pressed.connect(self.et_)
        self.viewh = QPushButton("Visit History")
        self.viewh.pressed.connect(self.viewh_)
        self.back = QPushButton("Back")
        self.back.pressed.connect(self.back_)
        self.vbox2.addWidget(self.et)
        self.vbox2.addWidget(self.viewh)
        self.vbox2.addWidget(self.back)

        self.mhbox.addLayout(self.vbox1)
        self.mhbox.addLayout(self.vbox2)

        self.setLayout(self.mhbox)

    def mu_(self):
        ManageUser().exec()

    def mc_(self):
        ManageCompany().exec()

    def cm_(self):
        CreateMovie().exec()

    def et_(self):
        ExploreTheater().exec()

    def visith_(self):
        VisitHistory().exec()

    def back_(self):
        self.close()
        Login().exec()

# DONE
class AdminCustomer(QDialog):

    def __init__(self):
        super(AdminCustomer, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Admin-Customer Functionality")

        self.mhbox = QHBoxLayout()

        self.vbox1 = QVBoxLayout()
        self.mu = QPushButton("Manager User")
        self.mu.pressed.connect(self.mu_)
        self.mc = QPushButton("Manage Company")
        self.mc.pressed.connect(self.mc_)
        self.cm = QPushButton("Create Movie")
        self.cm.pressed.connect(self.cm_)
        self.visith = QPushButton("Visit History")
        self.visith.pressed.connect(self.visith_)
        self.vbox1.addWidget(self.mu)
        self.vbox1.addWidget(self.mc)
        self.vbox1.addWidget(self.cm)
        self.vbox1.addWidget(self.visith)

        self.vbox2 = QVBoxLayout()
        self.em = QPushButton("Explore Movie")
        self.em.pressed.connect(self.em_)
        self.et = QPushButton("Explore Theater")
        self.et.pressed.connect(self.et_)
        self.viewh = QPushButton("View History")
        self.viewh.pressed.connect(self.viewh_)
        self.back = QPushButton("Back")
        self.back.pressed.connect(self.back_)
        self.vbox2.addWidget(self.em)
        self.vbox2.addWidget(self.et)
        self.vbox2.addWidget(self.viewh)
        self.vbox2.addWidget(self.back)

        self.mhbox.addLayout(self.vbox1)
        self.mhbox.addLayout(self.vbox2)

        self.setLayout(self.mhbox)

    def mu_(self):
        ManageUser().exec()

    def mc_(self):
        ManageCompany().exec()

    def cm_(self):
        CreateMovie().exec()

    def visith_(self):
        VisitHistory().exec()

    def em_(self):
        ExploreMovie().exec()

    def et_(self):
        ExploreTheater().exec()

    def viewh_(self):
        ViewHistory().exec()

    def back_(self):
        self.close()
        Login().exec()

# DONE
class ManagerOnly(QDialog):

    def __init__(self):
        super(ManagerOnly, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Manager-Only Functionality")

        self.mvbox = QVBoxLayout()
        self.mhbox = QHBoxLayout()

        self.vbox1 = QVBoxLayout()
        self.to = QPushButton("Theater Overview")
        self.to.pressed.connect(self.to_)
        self.sm = QPushButton("Schedule Movie")
        self.sm.pressed.connect(self.sm_)
        self.vbox1.addWidget(self.to)
        self.vbox1.addWidget(self.sm)

        self.vbox2 = QVBoxLayout()
        self.et = QPushButton("Explore Theater")
        self.et.pressed.connect(self.et_)
        self.vh = QPushButton("View History")
        self.vh.pressed.connect(self.vh_)
        self.vbox2.addWidget(self.et)
        self.vbox2.addWidget(self.vh)

        self.back = QPushButton("Back")
        self.back.pressed.connect(self.back_)

        self.mhbox.addLayout(self.vbox1)
        self.mhbox.addLayout(self.vbox2)

        self.mvbox.addLayout(self.mhbox)
        self.mvbox.addWidget(self.back)

        self.setLayout(self.mvbox)

    def to_(self):
        TheaterOverview().exec()

    def sm_(self):
        ScheduleMovie().exec()

    def et_(self):
        ExploreTheater().exec()

    def vh_(self):
        VisitHistory().exec()

    def back_(self):
        self.close()
        Login().exec()

# DONE
class ManagerCustomer(QDialog):

    def __init__(self):
        super(ManagerCustomer, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Manager-Customer Functionality")

        self.mvbox= QVBoxLayout()
        self.mhbox = QHBoxLayout()

        self.vbox1 = QVBoxLayout()
        self.to = QPushButton("Theater Overview")
        self.to.pressed.connect(self.to_)
        self.sm = QPushButton("Schedule Movie")
        self.sm.pressed.connect(self.sm_)
        self.viewh = QPushButton("View History")
        self.viewh.pressed.connect(self.viewh_)
        self.vbox1.addWidget(self.to)
        self.vbox1.addWidget(self.sm)
        self.vbox1.addWidget(self.viewh)

        self.vbox2 = QVBoxLayout()
        self.em = QPushButton("Explore Movie")
        self.em.pressed.connect(self.em_)
        self.et = QPushButton("Explore Theater")
        self.et.pressed.connect(self.et_)
        self.visith = QPushButton("Visit History")
        self.visith.pressed.connect(self.visith_)
        self.vbox2.addWidget(self.em)
        self.vbox2.addWidget(self.et)
        self.vbox2.addWidget(self.visith)

        self.back = QPushButton("Back")
        self.back.pressed.connect(self.back_)

        self.mhbox.addLayout(self.vbox1)
        self.mhbox.addLayout(self.vbox2)

        self.mvbox.addLayout(self.mhbox)
        self.mvbox.addWidget(self.back)

        self.setLayout(self.mvbox)

    def to_(self):
        TheaterOverview().exec()

    def sm_(self):
        ScheduleMovie().exec()

    def viewh_(self):
        ViewHistory().exec()

    def em_(self):
        ExploreMovie().exec()

    def et_(self):
        ExploreTheater().exec()

    def visith_(self):
        VisitHistory().exec()

    def back_(self):
        self.close()
        Login().exec()

# DONE
class Customer(QDialog):
    def __init__(self):
        super(Customer, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Customer Functionality")

        self.mvbox = QVBoxLayout()
        self.mhbox = QHBoxLayout()

        self.vbox1 = QVBoxLayout()
        self.em = QPushButton("Explore Movie")
        self.em.pressed.connect(self.em_)
        self.et = QPushButton("Explore Theater")
        self.et.pressed.connect(self.et_)
        self.vbox1.addWidget(self.em)
        self.vbox1.addWidget(self.et)

        self.vbox2 = QVBoxLayout()
        self.viewh = QPushButton("View History")
        self.viewh.pressed.connect(self.viewh_)
        self.visith = QPushButton("Visit History")
        self.visith.pressed.connect(self.visith_)
        self.vbox2.addWidget(self.viewh)
        self.vbox2.addWidget(self.visith)

        self.back = QPushButton("Back")
        self.back.pressed.connect(self.back_)

        self.mhbox.addLayout(self.vbox1)
        self.mhbox.addLayout(self.vbox2)

        self.mvbox.addLayout(self.mhbox)
        self.mvbox.addWidget(self.back)

        self.setLayout(self.mvbox)

    def em_(self):
        ExploreMovie().exec()

    def et_(self):
        ExploreTheater().exec()

    def viewh_(self):
        ViewHistory().exec()

    def visith_(self):
        VisitHistory().exec()

    def back_(self):
        self.close()
        Login().exec()

# DONE
class User(QDialog):

    def __init__(self):
        super(User, self).__init__()
        self.setModal(True)
        self.setWindowTitle("User Functionality")

        self.vbox1 = QVBoxLayout()
        self.et = QPushButton("Explore Theater")
        self.et.pressed.connect(self.et_)
        self.viewh = QPushButton("View History")
        self.viewh.pressed.connect(self.viewh_)
        self.back = QPushButton("Back")
        self.back.pressed.connect(self.back_)

        self.vbox1.addWidget(self.et)
        self.vbox1.addWidget(self.viewh)
        self.vbox1.addWidget(self.back)

        self.setLayout(self.vbox1)

    def et_(self):
        ExploreTheater().exec()

    def viewh_(self):
        ViewHistory().exec()

    def back_(self):
        self.close()
        Login().exec()

# DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
class ManageUser(QDialog):
    def __init__(self):
        super(ManageUser, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Manage User")

        self.username = QLineEdit()
        self.username.setText("")
        self.status = QComboBox()
        self.status.addItems(["ALL","Approved","Declined","Pending"])

        self.mvbox = QVBoxLayout()
        hbox1 = QHBoxLayout()

        hbox1.addWidget(QLabel("Username:"))
        hbox1.addWidget(self.username)
        hbox1.addWidget(QLabel("Status:"))
        hbox1.addWidget(self.status)

        self.mvbox.addLayout(hbox1)

        hbox2 = QHBoxLayout()
        filter_ = QPushButton("Filter")
        filter_.pressed.connect(self.filter__)
        approve = QPushButton("Approve")
        approve.pressed.connect(self.approve_)
        decline = QPushButton("Decline")
        decline.pressed.connect(self.decline_)

        hbox2.addWidget(filter_)
        hbox2.addWidget(approve)
        hbox2.addWidget(decline)

        self.mvbox.addLayout(hbox2)

        hbox3 = QHBoxLayout()
        hbox3.addWidget(QLabel("Sort By:"))
        self.s1 = QComboBox()
        stuff = ["","Username","Credit Card Count", "User Type", "Status"]
        stufff = ["","username","creditCardCount", "userType", "status"]
        self.stuffff = dict(zip(stufff, stuff))
        self.sstuff = dict(zip(stuff, stufff))
        self.s1.addItems(stuff)
        hbox3.addWidget(self.s1)
        self.mvbox.addLayout(hbox3)

        hbox4 = QHBoxLayout()
        hbox4.addWidget(QLabel("Sort Direction:"))
        self.s2 = QComboBox()
        self.s2.addItems(["","ASC","DESC"])
        hbox4.addWidget(self.s2)
        self.mvbox.addLayout(hbox4)

        sort = QPushButton("Sort")
        sort.pressed.connect(self.add_dataa)
        self.mvbox.addWidget(sort)

        self.add_data(self.username.text(),self.status.currentText())

        self.setLayout(self.mvbox)

    def add_data(self, username, status, sort_by = None, sort_dir = None):
        if not bool(sort_by):
            sort_by = ""
        else:
            sort_by = self.sstuff[sort_by]
        sort_dir = "" if None else sort_dir
        if username != "":
            if sort_by != "" or sort_dir != "":
                curs.execute(f'call admin_filter_user("{username}", "{status}", "{sort_by}","{sort_dir}");')
                curs.fetchall()
                curs.execute("SELECT * FROM AdFilterUser;")
                data = curs.fetchall()
            elif sort_by == "":
                curs.execute(f'call admin_filter_user("{username}", "{status}", "","{sort_dir}");')
                curs.fetchall()
                curs.execute("SELECT * FROM AdFilterUser;")
                data = curs.fetchall()
            elif sort_dir == "":
                curs.execute(f'call admin_filter_user("{username}", "{status}", "{sort_by}","");')
                curs.fetchall()
                curs.execute("SELECT * FROM AdFilterUser;")
                data = curs.fetchall()
        else:
            if sort_by != "" or sort_dir != "":
                curs.execute(f'call admin_filter_user("", "{status}", "{sort_by}","{sort_dir}");')
                curs.fetchall()
                curs.execute("SELECT * FROM AdFilterUser;")
                data = curs.fetchall()
            elif sort_by == "":
                curs.execute(f'call admin_filter_user("", "{status}", "","{sort_dir}");')
                curs.fetchall()
                curs.execute("SELECT * FROM AdFilterUser;")
                data = curs.fetchall()
            elif sort_dir == "":
                curs.execute(f'call admin_filter_user("", "{status}", "{sort_by}","");')
                curs.fetchall()
                curs.execute("SELECT * FROM AdFilterUser;")
                data = curs.fetchall()
        try:
            self.back.setParent(None)
            self.table_model.setParent(None)
            self.table_view.setParent(None)
        except:
            pass
        if bool(data):
            print(data[0].keys())
            data = [{"Username": i["username"], "Credit Card Count" : i["creditCardCount"], \
            "User Type" : i["userType"], "Status" : i["status"]} for i in data]
            # if bool(sort_by) and bool(sort_dir):
            #     if sort_dir == "ASC":
            #         data.sort(key = lambda x : x[sort_by])
            #     else:
            #         data.sort(key = lambda x : x[sort_by], reverse = True)
        else:
            data = [{i : "" for i in self.stuffff.keys() }]
        self.table_model = SimpleTableModel(data)
        self.table_view = QTableView()
        self.table_view.setModel(self.table_model)
        self.table_view.setSelectionMode(QAbstractItemView.SelectRows | QAbstractItemView.SingleSelection)
        self.mvbox.addWidget(self.table_view)

        self.back = QPushButton("Back")
        self.back.pressed.connect(self.back_)
        self.mvbox.addWidget(self.back)

    def add_dataa(self):
        self.add_data(self.username.text(), self.status.currentText(), self.s1.currentText(), self.s2.currentText())

    def filter__(self):
        self.add_data(self.username.text(), self.status.currentText(), self.s1.currentText(), self.s2.currentText())

    def approve_(self):
        current_index = self.table_view.currentIndex().row()
        selected_item = self.table_model.row(current_index)
        success = True
        try:
            curs.execute(f'call admin_approve_user("{selected_item["username"]}");')
            curs.fetchall()
            connection.commit()
        except Exception as e:
            success = False
            w = QMessageBox()
            QMessageBox.warning(w, "Approval Error", f"Cannot accept user {selected_item['username']}")
        if success:
            msgBox = QMessageBox()
            msgBox.setIcon(QMessageBox.Information)
            msgBox.setText(f"{selected_item['username']} Accepted!")
            msgBox.setWindowTitle("Approval Accepted")
            msgBox.setStandardButtons(QMessageBox.Ok | QMessageBox.Cancel)
            returnValue = msgBox.exec()
            if returnValue == QMessageBox.Ok:
                  msgBox.close()
        self.add_data(self.username.text(), self.status.currentText())

    def decline_(self):
        current_index = self.table_view.currentIndex().row()
        selected_item = self.table_model.row(current_index)
        success = True
        try:
            curs.execute(f'call admin_decline_user("{selected_item["username"]}");')
            curs.fetchall()
            connection.commit()
        except Exception as e:
            success = False
            w = QMessageBox()
            QMessageBox.warning(w, "Decline Error", f"Cannot decline user {selected_item['username']}")
        if success:
            msgBox = QMessageBox()
            msgBox.setIcon(QMessageBox.Information)
            msgBox.setText(f"{selected_item['username']} Declined..")
            msgBox.setWindowTitle("Decline Accepted")
            msgBox.setStandardButtons(QMessageBox.Ok | QMessageBox.Cancel)
            returnValue = msgBox.exec()
            if returnValue == QMessageBox.Ok:
                  msgBox.close()
        self.add_data(self.username.text(), self.status.currentText())

    def back_(self):
        self.close()

# DONE!!!!!
class ManageCompany(QDialog):
    def __init__(self):
        super(ManageCompany, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Manage Company")

        self.name = QComboBox()
        dum = getCompanyNames()
        self.name.addItems(["ALL"] + dum)

        self.c1 = QLineEdit()
        self.c2 = QLineEdit()
        self.t1 = QLineEdit()
        self.t2 = QLineEdit()
        self.e1 = QLineEdit()
        self.e2 = QLineEdit()

        self.mvbox = QVBoxLayout()

        hbox1 = QHBoxLayout()
        hbox1.addWidget(QLabel("Name:"))
        hbox1.addWidget(self.name)
        hbox1.addWidget(QLabel("# City Covered"))
        hbox1.addWidget(self.c1)
        hbox1.addWidget(QLabel(" -- "))
        hbox1.addWidget(self.c2)

        self.mvbox.addLayout(hbox1)

        hbox2 = QHBoxLayout()
        hbox2.addWidget(QLabel("# Theaters"))
        hbox2.addWidget(self.t1)
        hbox2.addWidget(QLabel(" -- "))
        hbox2.addWidget(self.t2)
        hbox2.addWidget(QLabel("# Employees"))
        hbox2.addWidget(self.e1)
        hbox2.addWidget(QLabel(" -- "))
        hbox2.addWidget(self.e2)

        self.mvbox.addLayout(hbox2)

        hbox2 = QHBoxLayout()
        filter_ = QPushButton("Filter")
        filter_.pressed.connect(self.filter__)
        ct = QPushButton("Create Theater")
        ct.pressed.connect(self.ct_)
        detail = QPushButton("Detail")
        detail.pressed.connect(self.detail_)

        hbox2.addWidget(filter_)
        hbox2.addWidget(ct)
        hbox2.addWidget(detail)

        self.mvbox.addLayout(hbox2)

        hbox3 = QHBoxLayout()
        hbox3.addWidget(QLabel("Sort By:"))

        stuff = ["","Name","#CityCovered", "#Theaters", "#Employee"]
        stufff = ["","comName","numCityCover", "numTheater", "numEmployee"]
        self.s1 = QComboBox()
        self.stuffff = dict(zip(stufff, stuff))
        self.sstuff = dict(zip(stuff, stufff))
        self.s1.addItems(stuff)
        hbox3.addWidget(self.s1)
        self.mvbox.addLayout(hbox3)

        hbox4 = QHBoxLayout()
        hbox4.addWidget(QLabel("Sort Direction:"))
        self.s2 = QComboBox()
        self.s2.addItems(["","ASC","DESC"])
        hbox4.addWidget(self.s2)
        self.mvbox.addLayout(hbox4)

        sort = QPushButton("Sort")
        sort.pressed.connect(self.add_dataa)
        self.mvbox.addWidget(sort)

        # DO SOMETHING HERE
        self.add_data(self.name.currentText(), self.c1.text(), self.c2.text(), \
            self.t1.text(), self.t2.text(), self.e1.text(), self.e2.text(),
            self.s1.currentText(), self.s2.currentText())

        self.setLayout(self.mvbox)

    def add_data(self, name, c1, c2, t1, t2, e1, e2, s1, s2):
        if c1 == "":
            c1 = 0
        if c2 == "":
            c2 = 2 ** 20
        if t1 == "":
            t1 = 0
        if t2 == "":
            t2 = 2 ** 20
        if e1 == "":
            e1 = 0
        if e2 == "":
            e2 = 2 ** 20
        if s1 != "":
            s1 = self.sstuff[s1]
        # company_name, mincity, max_city, min theater, max theater, min emp, max emp, sort by , sort dir
        curs.execute(f'call admin_filter_company("{name}", "{c1}", "{c2}","{t1}","{t2}","{e1}","{e2}","{s1}","{s2}");')
        curs.fetchall()
        curs.execute("SELECT * FROM AdFilterCom;")
        data = curs.fetchall()
        try:
            self.back.setParent(None)
            self.table_model.setParent(None)
            self.table_view.setParent(None)
        except:
            pass
        if bool(data):
            data = [{"Name" : i["comName"], "#CityCovered" : i["numCityCover"] , \
            "#Theaters": i["numTheater"], "#Employees": i["numEmployee"] } for i in data]
        else:
            data = [{i : "" for i in self.stuffff.keys() }]
        self.table_model = SimpleTableModel(data)
        self.table_view = QTableView()
        self.table_view.setModel(self.table_model)
        self.table_view.setSelectionMode(QAbstractItemView.SelectRows | QAbstractItemView.SingleSelection)
        self.mvbox.addWidget(self.table_view)

        self.back = QPushButton("Back")
        self.back.pressed.connect(self.back_)
        self.mvbox.addWidget(self.back)

    def add_dataa(self):
        self.add_data(self.name.currentText(), self.c1.text(), self.c2.text(), \
            self.t1.text(), self.t2.text(), self.e1.text(), self.e2.text(),
            self.s1.currentText(), self.s2.currentText())

    def filter__(self):
        self.add_data(self.name.currentText(), self.c1.text(), self.c2.text(), \
            self.t1.text(), self.t2.text(), self.e1.text(), self.e2.text(),
            self.s1.currentText(), self.s2.currentText())

    def back_(self):
        self.close()

    def ct_(self):
        CreateTheater().exec()

    def detail_(self):
        dum = self.name.currentText()
        if dum == "ALL":
            w = QMessageBox()
            QMessageBox.warning(w, "Company Detail Error", f"Cannot view data for all companies")
        else:
            CompanyDetail(dum).exec()

# DONE!!!
class CreateTheater(QDialog):
    def __init__(self):
        super(CreateTheater, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Create Theater")

        self.name = QLineEdit()
        self.comp = QComboBox()
        self.comps = getCompanyNames()
        self.comp.addItems(self.comps)
        self.street = QLineEdit()
        self.city = QLineEdit()
        self.state = QComboBox()
        self.state.addItems(getStates())
        self.zip_ = QLineEdit()
        self.cap = QLineEdit()
        self.manager = QComboBox()
        self.mans = getManagerNames()
        self.manager.addItems(self.mans)

        mvbox = QVBoxLayout()

        hbox1 = QHBoxLayout()
        hbox1.addWidget(QLabel("Name:"))
        hbox1.addWidget(self.name)
        hbox1.addWidget(QLabel("Company:"))
        hbox1.addWidget(self.comp)

        mvbox.addLayout(hbox1)

        hbox2 = QHBoxLayout()
        hbox2.addWidget(QLabel("Street Address:"))
        hbox2.addWidget(self.street)

        mvbox.addLayout(hbox2)

        hbox3 = QHBoxLayout()
        hbox3.addWidget(QLabel("City"))
        hbox3.addWidget(self.city)
        hbox3.addWidget(QLabel("State"))
        hbox3.addWidget(self.state)
        hbox3.addWidget(QLabel("Zipcode"))
        hbox3.addWidget(self.zip_)

        mvbox.addLayout(hbox3)

        hbox4 = QHBoxLayout()
        hbox4.addWidget(QLabel("Capacity"))
        hbox4.addWidget(self.cap)
        hbox4.addWidget(QLabel("Manager"))
        hbox4.addWidget(self.manager)

        mvbox.addLayout(hbox4)

        hbox5 = QHBoxLayout()
        back = QPushButton("Back")
        back.pressed.connect(self.back_)
        create = QPushButton("Create")
        create.pressed.connect(self.create_)
        hbox5.addWidget(back)
        hbox5.addWidget(create)

        mvbox.addLayout(hbox5)

        self.setLayout(mvbox)

    def back_(self):
        self.close()
        RegisterNavigation().exec()

    def create_(self):
        # Create theater
        name = self.name.text()
        comp = self.comp.currentText()
        street = self.street.text()
        city = self.city.text()
        state = self.state.currentText()
        zip_ = self.zip_.text()
        cap = self.cap.text()
        manager = self.manager.currentText()
        try:
            dum = getManagersAtCompany(comp)
            if manager in dum:
                curs.execute(f'call admin_create_theater("{name}","{comp}","{street}","{city}","{state}","{zip_}","{cap}","{manager}")')
                self.name.setText("")
                self.street.setText("")
                self.city.setText("")
                self.zip_.setText("")
                self.cap.setText("")
            else:
                w = QMessageBox()
                QMessageBox.warning(w, "Create Theater Error", f"Manager, {manager} not employed at company {comp}.")
        except Exception as e:
            w = QMessageBox()
            QMessageBox.warning(w, "Create Theater Error", f"The following exception occured...\n{e}")

# DONE! (I think)
class CompanyDetail(QDialog):
    def __init__(self, comp_name):
        super(CompanyDetail, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Company Detail")

        mvbox = QVBoxLayout()

        hbox1 = QHBoxLayout()
        hbox1.addWidget(QLabel("Name:" + comp_name))

        mvbox.addLayout(hbox1)

        hbox2 = QHBoxLayout()
        username_mappings = getUserNameMapping()
        mans = getManagersAtCompany(comp_name)
        mans = [username_mappings[i] for i in mans]
        val = ", ".join(mans)
        hbox2.addWidget(QLabel("Employees:   " + val))

        mvbox.addLayout(hbox2)

        mvbox.addWidget(QLabel("Theaters:   "))

        curs.execute(f'call admin_view_comdetail_th("{comp_name}");')
        curs.fetchall()
        curs.execute("SELECT * FROM adcomdetailth;")
        data1 = curs.fetchall()

        data1 = [{"Name":i["thName"], "Manager":username_mappings[i["thManagerUsername"]], "City":i["thCity"], \
                "State":i["thState"], "Capacity":i["thCapacity"]} for i in data1]

        table_model = SimpleTableModel(data1)
        table_view = QTableView()
        table_view.setModel(table_model)
        table_view.setSelectionMode(QAbstractItemView.SelectRows | QAbstractItemView.SingleSelection)

        mvbox.addWidget(table_view)

        back = QPushButton("Back")
        back.pressed.connect(self.back_)
        self.setLayout(mvbox)

    def back_(self):
        self.close()

# DONE! (I think)
class CreateMovie(QDialog):
    def __init__(self):
        super(CreateMovie, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Create Movie")

        self.name = QLineEdit()
        self.duration = QLineEdit()
        self.date = QLineEdit()

        mvbox = QVBoxLayout()

        hbox1 = QHBoxLayout()
        hbox1.addWidget(QLabel("Name:"))
        hbox1.addWidget(self.name)
        hbox1.addWidget(QLabel("Duration:"))
        hbox1.addWidget(self.duration)

        mvbox.addLayout(hbox1)

        hbox2 = QHBoxLayout()
        hbox2.addWidget(QLabel("Release Date"))
        hbox2.addWidget(self.date)

        mvbox.addLayout(hbox2)

        hbox3 = QHBoxLayout()
        back = QPushButton("Back")
        back.pressed.connect(self.back_)
        create = QPushButton("Create")
        create.pressed.connect(self.create_)
        hbox3.addWidget(back)
        hbox3.addWidget(create)

        mvbox.addLayout(hbox3)

        self.setLayout(mvbox)

    def back_(self):
        self.close()

    def create_(self):
        name = self.name.text()
        dur = self.duration.text()
        date = self.date.text()
        try:
            curs.execute(f'call admin_create_mov("{name}","{dur}","{date}");')
            self.name.setText("")
            self.duration.setText("")
            self.date.setText("")
        except Exception as e:
            w = QMessageBox()
            QMessageBox.warning(w, "Create Movie Error", f"The following exception occured...\n{e}")

# DONE!
class TheaterOverview(QDialog):
    def __init__(self):
        super(TheaterOverview, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Theater Overview")

        

        self.vbox = QVBoxLayout()
        self.hbox1 = QHBoxLayout()
        self.hbox2 = QHBoxLayout()
        self.hbox3 = QHBoxLayout()
        self.hbox4 = QHBoxLayout()
        self.hbox5 = QHBoxLayout()

        self.mn = QLineEdit()
        self.md1 = QLineEdit()
        self.md2 = QLineEdit()
        self.mrd1 = QLineEdit()
        self.mrd2 = QLineEdit()
        self.mpd1 = QLineEdit()
        self.mpd2 = QLineEdit()
        self.inclusion = QComboBox()
        self.inclusion.addItems(['All', 'Only include not played movies'])
        
        self.data1 = [{}]


        self.hbox1.addWidget(QLabel("Movie Name:"))
        self.hbox1.addWidget(self.mn)
        self.hbox1.addWidget(QLabel("Movie Duration:"))
        self.hbox1.addWidget(self.md1)
        self.hbox1.addWidget(QLabel(" -- "))
        self.hbox1.addWidget(self.md2)
        self.hbox2.addWidget(QLabel("Movie Release Date:"))
        self.hbox2.addWidget(self.mrd1)
        self.hbox2.addWidget(QLabel(" -- "))
        self.hbox2.addWidget(self.mrd2)
        self.hbox3.addWidget(QLabel("Movie Play Date:"))
        self.hbox3.addWidget(self.mpd1)
        self.hbox3.addWidget(QLabel(" -- "))
        self.hbox3.addWidget(self.mpd2)
        self.hbox3.addWidget(self.inclusion)

        self.filter_ = QPushButton("Filter")

        self.hbox4.addWidget(self.filter_)
        self.vbox.addLayout(self.hbox1)
        self.vbox.addLayout(self.hbox2)
        self.vbox.addLayout(self.hbox3)
        self.vbox.addLayout(self.hbox4)

        self.table_model = SimpleTableModel(self.data1)
        self.table_view = QTableView()
        self.table_view.setModel(self.table_model)
        self.table_view.setSelectionMode(QAbstractItemView.SelectRows | QAbstractItemView.SingleSelection)

        self.vbox.addWidget(self.table_view)
        self.back = QPushButton("Back")
        self.vbox.addWidget(self.back)

        self.setLayout(self.vbox)
    
    def filter__(self):
        pass

    def back_(self):
        pass

# DONE! (I think)
class ScheduleMovie(QDialog):
    def __init__(self):
        super(ScheduleMovie, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Schedule Movie")

        vbox = QVBoxLayout()

        hbox1 = QHBoxLayout()
        hbox2 = QHBoxLayout()
        hbox3 = QHBoxLayout()

        movies = getMovies()
        self.movie = QComboBox()
        self.movie.addItems(movies)
        self.date = QLineEdit()

        hbox1.addWidget(QLabel("Name:"))
        hbox1.addWidget(self.movie)
        hbox1.addWidget(QLabel("Release Date:"))
        hbox1.addWidget(self.date)

        self.play_date = QLineEdit()
        hbox2.addWidget(QLabel("Play Date:"))
        hbox2.addWidget(self.play_date)

        back = QPushButton("Back")
        back.pressed.connect(self.back_)
        add = QPushButton("Add")
        add.pressed.connect(self.add_)

        hbox3.addWidget(back)
        hbox3.addWidget(add)

        vbox.addLayout(hbox1)
        vbox.addLayout(hbox2)
        vbox.addLayout(hbox3)

        self.setLayout(vbox)

    def back_(self):
        self.close()

    def add_(self):
        mov = self.movie.currentText()
        r_date = self.date.text()
        p_date = self.play_date.text()
        try:
            curs.execute(f'call manager_schedule_mov("{USERNAME}","{mov}","{r_date}","{p_date}");')
            self.date.setText("")
            self.play_date.setText("")
        except Exception as e:
            w = QMessageBox()
            QMessageBox.warning(w, "Scheduling Error", f"The following exception occured...\n{e}")
            self.date.setText("")
            self.play_date.setText("")

# DONE!!
class ExploreMovie(QDialog):
    def __init__(self):
        super(ExploreMovie, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Explore Movie")

        curs.execute("SELECT * FROM movieplay WHERE TRUE;")
        moviePlays = curs.fetchall()
        self.data1 = []

        for i in moviePlays:
            theater = i["thName"]
            company = i["comName"]
            movie = i["movName"]
            playDate = i["movPlayDate"]
            curs.execute(f"SELECT * FROM theater WHERE thName = '{theater}' AND comName = '{company}';")
            address = curs.fetchall()
            address = address[0]["thStreet"] + ", " + address[0]["thCity"] + ", " + address[0]["thState"] + " " + str(address[0]["thZipcode"])
            dictionary = {
                "Movie": movie,
                "Theater": theater,
                "Address": address,
                "Company": company,
                "PlayDate": playDate
            }
            self.data1.append(dictionary)

        self.vbox = QVBoxLayout()


        self.mn = QComboBox()
        self.mn.addItems(["ALL"] + list(set([i["Movie"] for i in self.data1])))

        self.comp = QComboBox()
        self.comp.addItems(["ALL"] + list(set([i["Company"] for i in self.data1])))

        self.city = QLineEdit()

        self.state = QComboBox()
        self.states = getStates()
        self.state.addItems(['All'] + self.states)

        self.filter_ = QPushButton("Filter")
        self.filter_.pressed.connect(self.filter__)

        self.hbox1 = QHBoxLayout()
        self.hbox1.addWidget(QLabel("Movie Name:"))
        self.hbox1.addWidget(self.mn)
        self.hbox1.addWidget(QLabel("Company Name:"))
        self.hbox1.addWidget(self.comp)

        self.hbox2 = QHBoxLayout()
        self.hbox2.addWidget(QLabel("City:"))
        self.hbox2.addWidget(self.city)
        self.hbox2.addWidget(QLabel("State:"))
        self.hbox2.addWidget(self.state)

        self.hbox2_5 = QHBoxLayout()
        self.mpd1 = QLineEdit()
        self.mpd2 = QLineEdit()
        self.hbox2_5.addWidget(QLabel("Movie Play Date:"))
        self.hbox2_5.addWidget(self.mpd1)
        self.hbox2_5.addWidget(QLabel(" -- "))
        self.hbox2_5.addWidget(self.mpd2)

        self.vbox.addLayout(self.hbox1)
        self.vbox.addLayout(self.hbox2)
        self.vbox.addLayout(self.hbox2_5)
        self.vbox.addWidget(self.filter_)

        self.table_model = SimpleTableModel(self.data1)
        self.table_view = QTableView()
        self.table_view.setModel(self.table_model)
        self.table_view.setSelectionMode(QAbstractItemView.SelectRows | QAbstractItemView.SingleSelection)

        self.vbox.addWidget(self.table_view)

        self.hbox3 = QHBoxLayout()
        self.back = QPushButton("Back")
        self.back.pressed.connect(self.back_)
        self.cnum_combo = QComboBox()
        self.cnum_combo.addItems(getCreditCards(USERNAME))
        self.view = QPushButton("View")
        self.view.pressed.connect(self.view_)

        self.hbox3.addWidget(self.back)
        self.hbox3.addWidget(QLabel("Card Number:"))
        self.hbox3.addWidget(self.cnum_combo)
        self.hbox3.addWidget(self.view)

        self.vbox.addLayout(self.hbox3)

        self.setLayout(self.vbox)

    def filter__(self):
        # `customer_view_mov`(IN  i_creditCardNum CHAR(16), IN i_movName VARCHAR(50), IN i_movReleaseDate DATE, IN i_thName VARCHAR(50), IN i_comName VARCHAR(50), IN i_movPlayDate DATE)
        # `customer_filter_mov`(IN i_movName VARCHAR(50), IN i_comName VARCHAR(50), IN i_city VARCHAR(50), IN i_state CHAR(3), IN i_minMovPlayDate DATE, IN i_maxMovPlayDate DATE)
        movieName = self.mn.currentText()
        company = self.comp.currentText()
        city = self.city.text()
        state = self.state.currentText()
        minDate = self.mpd1.text()
        maxDate = self.mpd2.text()
        MIN_DATE, MAX_DATE = getMinAndMaxDateMoviePlay()
        if minDate == "":
            minDate = MIN_DATE
        if maxDate == "":
            maxDate = MAX_DATE

        try: 
            curs.execute(f'call customer_filter_mov("{movieName}","{company}","{city}", "{state}", "{minDate}", "{maxDate}");')
        except: 
            b = QMessageBox()
            QMessageBox.warning(b, "Error", "Your date is the wrong format")
        
        dum1 = curs.fetchall()
        dum = curs.execute('SELECT * FROM CosFilterMovie;')
        dum2 = curs.fetchall()
        print(dum2)

        if not dum:
            dum3 = [{"Theater":"","Address":"","Company":""}]
        else:
            dum3 = [{
                "Movie": i["movName"],
                "Theater" : i["thName"],
                "Address" : i["thStreet"] + ", " + i["thCity"] + ", " + i["thState"] + " " + str(i["thZipcode"]),
                "Company" : i["comName"],
                "PlayDate" : i["movPlayDate"]
            } for i in dum2]

        self.table_model.setParent(None)
        self.table_view.setParent(None)
        self.hbox3.setParent(None)
        self.vbox.addWidget(self.filter_)
        self.table_model = SimpleTableModel(dum3)
        self.table_view = QTableView()
        self.table_view.setModel(self.table_model)
        self.table_view.setSelectionMode(QAbstractItemView.SelectRows | QAbstractItemView.SingleSelection)

        self.vbox.addWidget(self.table_view)
        self.hbox3 = QHBoxLayout()
        self.back = QPushButton("Back")
        self.back.pressed.connect(self.back_)
        self.cnum_combo = QComboBox()
        self.cnum_combo.addItems(getCreditCards(USERNAME))
        self.view = QPushButton("View")
        self.view.pressed.connect(self.view_)

        self.hbox3.addWidget(self.back)
        self.hbox3.addWidget(QLabel("Card Number:"))
        self.hbox3.addWidget(self.cnum_combo)
        self.hbox3.addWidget(self.view)

        self.vbox.addLayout(self.hbox3)

        self.setLayout(self.vbox)

    def back_(self):
        self.close()

    def view_(self):
        # pass
        # `customer_view_mov`(IN  i_creditCardNum CHAR(16), IN i_movName VARCHAR(50), IN i_movReleaseDate DATE, IN i_thName VARCHAR(50), IN i_comName VARCHAR(50), IN i_movPlayDate DATE)
        current_index = self.table_view.currentIndex().row()
        selected_item = self.table_model.row(current_index)

        ccard = self.cnum_combo.currentText()
        movie = selected_item['Movie']

        curs.execute(f"SELECT * FROM movie WHERE movName = '{movie}';")
        movieInfo = curs.fetchall()
        print(movieInfo)

        releaseDate = movieInfo[0]['movReleaseDate'] # write this
        theater = selected_item['Theater']
        company = selected_item['Company']
        playDate = selected_item['PlayDate']

        try:
            curs.execute(f'call customer_view_mov("{ccard}", "{movie}", "{releaseDate}", "{theater}", "{company}", "{playDate}");')
            connection.commit()
        except: 
            b = QMessageBox()
            QMessageBox.warning(b, "Error", "Your date is the wrong format")

# DONE! (I think)
class ViewHistory(QDialog):
    def __init__(self):
        super(ViewHistory, self).__init__()
        self.setModal(True)
        self.setWindowTitle("View History")

        vbox = QVBoxLayout()

        curs.execute(f'call customer_view_history("{USERNAME}");')
        dum1 = curs.fetchall()
        dum = curs.execute('SELECT * FROM CosViewHistory;')
        dum2 = curs.fetchall()

        if not dum:
            dum2 = [{"Movie": "","Theater":"","Company":"","Card#":"","View Date":""}]

        table_model = SimpleTableModel(dum2)
        table_view = QTableView()
        table_view.setModel(table_model)
        table_view.setSelectionMode(QAbstractItemView.SelectRows | QAbstractItemView.SingleSelection)

        vbox.addWidget(QLabel("View History for " + USERNAME))
        vbox.addWidget(table_view)

        self.setLayout(vbox)

# DONE
class ExploreTheater(QDialog):
    def __init__(self):
        super(ExploreTheater, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Explore Theater")

        curs.execute("SELECT * FROM theater WHERE TRUE;")
        data = curs.fetchall()
        data1 = [{"Theater" : i["thName"], "Address" : i["thStreet"] + ", " + \
                i["thCity"] + ", " + i["thState"] + " " + str(i["thZipcode"]), \
                "Company" : i["comName"]} for i in data]

        self.vbox = QVBoxLayout()
        hbox1 = QHBoxLayout()
        hbox2 = QHBoxLayout()

        self.tn = QComboBox()
        self.tn.addItems(["ALL"] + list(set([i["Theater"] for i in data1])))
        self.comp = QComboBox()
        self.comp.addItems(["ALL"] + list(set([i["Company"] for i in data1])))
        self.city = QLineEdit()
        self.state = QComboBox()
        self.state.addItems(["ALL"] + list(set([i["thState"] for i in data])))

        self.filter_ = QPushButton("Filter")
        self.filter_.pressed.connect(self.filter__)

        hbox1.addWidget(QLabel("Theater Name:"))
        hbox1.addWidget(self.tn)
        hbox1.addWidget(QLabel("Company Name:"))
        hbox1.addWidget(self.comp)

        hbox2.addWidget(QLabel("City:"))
        hbox2.addWidget(self.city)
        hbox2.addWidget(QLabel("State:"))
        hbox2.addWidget(self.state)

        self.vbox.addLayout(hbox1)
        self.vbox.addLayout(hbox2)
        self.vbox.addWidget(self.filter_)

        self.table_model = SimpleTableModel(data1)
        self.table_view = QTableView()
        self.table_view.setModel(self.table_model)
        self.table_view.setSelectionMode(QAbstractItemView.SelectRows | QAbstractItemView.SingleSelection)

        self.vbox.addWidget(self.table_view)

        self.hbox3 = QHBoxLayout()
        self.back = QPushButton("Back")
        self.back.pressed.connect(self.back_)
        self.vd = QLineEdit()
        self.lv = QPushButton("Log Visit")
        self.lv.pressed.connect(self.lv_)

        self.hbox3.addWidget(self.back)
        self.hbox3.addWidget(QLabel("Visit Date:"))
        self.hbox3.addWidget(self.vd)
        self.hbox3.addWidget(self.lv)

        self.vbox.addLayout(self.hbox3)

        self.setLayout(self.vbox)

    def filter__(self):
        company = self.comp.currentText()
        theaterName = self.tn.currentText()
        city = self.city.text()
        state = self.state.currentText()

        curs.execute(f'call user_filter_th("{theaterName}","{company}","{city}", "{state}");')
        dum1 = curs.fetchall()
        dum = curs.execute('SELECT * FROM UserFilterTh;')
        dum2 = curs.fetchall()

        if not dum:
            dum3 = [{"Theater":"","Address":"","Company":""}]
        else:
            dum3 = [{"Theater" : i["thName"], "Address" : i["thStreet"] + ", " + \
                i["thCity"] + ", " + i["thState"] + " " + str(i["thZipcode"]), \
                "Company" : i["comName"]} for i in dum2]
        self.table_model.setParent(None)
        self.table_view.setParent(None)
        self.hbox3.setParent(None)
        self.vbox.addWidget(self.filter_)
        self.table_model = SimpleTableModel(dum3)
        self.table_view = QTableView()
        self.table_view.setModel(self.table_model)
        self.table_view.setSelectionMode(QAbstractItemView.SelectRows | QAbstractItemView.SingleSelection)

        self.vbox.addWidget(self.table_view)
        self.hbox3 = QHBoxLayout()
        self.back = QPushButton("Back")
        self.back.pressed.connect(self.back_)
        self.vd = QLineEdit()
        self.lv = QPushButton("Log Visit")
        self.lv.pressed.connect(self.lv_)

        self.hbox3.addWidget(self.back)
        self.hbox3.addWidget(QLabel("Visit Date:"))
        self.hbox3.addWidget(self.vd)
        self.hbox3.addWidget(self.lv)

        self.vbox.addLayout(self.hbox3)

        self.setLayout(self.vbox)

    def back_(self):
        self.close()

    def lv_(self): # log visit helper
        # `user_visit_th`(IN i_thName VARCHAR(50), IN i_comName VARCHAR(50), IN i_visitDate DATE, IN i_username VARCHAR(50))
        current_index = self.table_view.currentIndex().row()
        selected_item = self.table_model.row(current_index)
        theater = selected_item["Theater"]
        company = selected_item["Company"]
        visitDate = self.vd.text()
        username = USERNAME
        if not visitDate == "":
            try: 
                curs.execute(f'call user_visit_th("{theater}", "{company}", "{visitDate}", "{username}");')
                connection.commit()
            except: 
                b = QMessageBox()
                QMessageBox.warning(b, "Error", "Your date is the wrong format")
        else:
            b = QMessageBox()
            QMessageBox.warning(b, "Null Error", "You are missing a visit date")

# DONE! (I think)
class VisitHistory(QDialog):
    def __init__(self, ):
        super(VisitHistory, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Visit History")

        MIN_DATE, MAX_DATE = getMinAndMaxDate()
        MIN_DATE, MAX_DATE = str(MIN_DATE), str(MAX_DATE)
        curs.execute(f'call user_filter_visithistory("{USERNAME}","{MIN_DATE}","{MAX_DATE}");')
        dum1 = curs.fetchall()
        dum = curs.execute('SELECT * FROM uservisithistory;')
        dum2 = curs.fetchall()

        if not dum:
            dum2 = [{"Theater":"","Address":"","Company":"","Visit Date":""}]
        else:
            dum2 = [{"Theater":i["thName"],"Address":f'{i["thStreet"]}, {i["thCity"]}, {i["thState"]} {i["thZipcode"]}',\
                "Company": i["comName"],"Visit Date":i["visitDate"]} for i in dum2]

        self.vbox = QVBoxLayout()

        hbox = QHBoxLayout()
        comps = list(set([i["Company"] for i in dum2]))
        self.comp = QComboBox()
        self.comp.addItems(["ALL"] + comps)
        self.vd1 = QLineEdit()
        self.vd2 = QLineEdit()

        hbox.addWidget(QLabel("Company Name:"))
        hbox.addWidget(self.comp)
        hbox.addWidget(QLabel("Visit Date:"))
        hbox.addWidget(self.vd1)
        hbox.addWidget(QLabel(" -- "))
        hbox.addWidget(self.vd2)

        self.vbox.addLayout(hbox)

        filter_ = QPushButton("Filter")
        filter_.pressed.connect(self.filter__)

        self.vbox.addWidget(filter_)

        self.table_model = SimpleTableModel(dum2)
        self.table_view = QTableView()
        self.table_view.setModel(self.table_model)
        self.table_view.setSelectionMode(QAbstractItemView.SelectRows | QAbstractItemView.SingleSelection)

        self.vbox.addWidget(QLabel("Visit History for " + USERNAME))
        self.vbox.addWidget(self.table_view)

        back = QPushButton("Back")
        back.pressed.connect(self.back_)


        self.setLayout(self.vbox)

    def filter__(self):
        self.the_comp = self.comp.currentText()
        MIN_DATE, MAX_DATE = getMinAndMaxDate()
        if not self.vd1.text():
            ovd1 = MIN_DATE
        else:
            ovd1 = self.vd1.text()
        if not self.vd2.text():
            ovd2 = MAX_DATE
        else:
            ovd2 = self.vd2.text()
        curs.execute(f'call user_filter_visithistory("{USERNAME}","{ovd1}","{ovd2}");')
        dum1 = curs.fetchall()
        dum = curs.execute('SELECT * FROM uservisithistory;')
        dum2 = curs.fetchall()

        if not dum:
            dum2 = [{"Theater":"","Address":"","Company":"","Visit Date":""}]
        else:
            dum2 = [{"Theater":i["thName"],"Address":f'{i["thStreet"]}, {i["thCity"]}, {i["thState"]} {i["thZipcode"]}',\
                "Company": i["comName"],"Visit Date":i["visitDate"]} for i in dum2]
        if self.the_comp != "ALL":
            dum2 = [i for i in dum2 if i["Company"] == self.the_comp]
        self.table_model.setParent(None)
        self.table_view.setParent(None)
        self.table_model = SimpleTableModel(dum2)
        self.table_view = QTableView()
        self.table_view.setModel(self.table_model)
        self.table_view.setSelectionMode(QAbstractItemView.SelectRows | QAbstractItemView.SingleSelection)

        self.vbox.addWidget(self.table_view)
        # self.close()
        # VisitHistory(data).exec()

    def back_(self):
        self.close()

if __name__ == '__main__':
    global connection, curs
    app = QApplication(sys.argv)
    # sys.argv = ["team11_gui.py", "asdf"]
    password = sys.argv[1]

    try:
        connection = pymysql.connect(host="localhost",
                                     user="root",
                                     password=password,
                                     db="team11",
                                     charset='utf8mb4',
                                     cursorclass=pymysql.cursors.DictCursor)
        curs = connection.cursor()
    except Exception as e:
        print(f"Couldn't log {login.user.text()} in to MySQL server on {login.host.text()}")
        print(e)
        app.quit()
        sys.exit()
    log = Login()
    log.show()
    sys.exit(app.exec_())
