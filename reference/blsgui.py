import pymysql
import sys
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
    QDialogButtonBox,
    QFormLayout,
    QLineEdit,
    QTableView,
    QAbstractItemView,
    QLabel,
    qApp
)
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavigationToolbar
from matplotlib.font_manager import FontProperties
import matplotlib.pyplot as plt


class DataStatistics(QDialog):
    def __init__(self, data, industry, extra_options, parent=None):
        super(DataStatistics, self).__init__(parent)
        self.figure = plt.figure()
        self.canvas = FigureCanvas(self.figure)
        self.toolbar = NavigationToolbar(self.canvas, self)
        self.data = data
        self.industry = industry

        self.select = QComboBox()
        self.select.addItems(['Aggregate Level Titles', 'Ownership Titles'] + extra_options)
        form_group_box = QGroupBox("Statistics of Selected Data")
        layout = QFormLayout()
        layout.addRow(QLabel("Plot:"), self.select)
        form_group_box.setLayout(layout)

        self.plot = QPushButton('Plot')
        self.plot.clicked.connect(self.run_plot)
        ok = QPushButton('Close')
        ok.clicked.connect(self.accept)

        layout = QVBoxLayout()
        layout.addWidget(form_group_box)
        layout.addWidget(self.toolbar)
        layout.addWidget(self.canvas)
        layout.addWidget(self.plot)
        layout.addWidget(ok)
        self.setLayout(layout)

    def run_plot(self):
        labels = []
        graph = ''
        if self.select.currentText() == 'Aggregate Level Titles':
            graph = 'pie'
            data = [list(i.values())[3] for i in self.data]
            data = {i:data.count(i) for i in data}
            for i in data.keys():
                curs.execute(f'select agglvl_title from agglvl_titles where agglvl_code={i};')
                labels.append(list(curs.fetchone().values())[0])
        elif self.select.currentText() == 'Ownership Titles':
            graph = 'pie'
            data = [list(i.values())[1] for i in self.data]
            data = {i:data.count(i) for i in data}
            labels = []
            for i in data.keys():
                curs.execute(f'select own_title from own_titles where own_code={i};')
                labels.append(list(curs.fetchone().values())[0])
        else:
            if self.select.currentText() == 'Total Quarterly Wages':
                index = 11
            elif self.select.currentText() == 'Average Weekly Wages':
                index = 12
            elif self.select.currentText() == 'Average Annual Pay':
                index = 9
            elif self.select.currentText() == 'Average Annual Weekly Wages':
                index = 8
            elif self.select.currentText() == 'Annual Average Establishments':
                index = 6
            data = [list(i.values())[index] for i in self.data]

        self.figure.clear()
        ax = self.figure.add_subplot(111)

        if graph == 'pie':
            frontP = FontProperties()
            frontP.set_size('small')
            patches, texts, autotexts = ax.pie(data.values(), autopct='%1.1f%%', startangle=90)
            ax.legend(patches, labels, title=self.select.currentText(), loc='lower center',
                      prop=frontP, bbox_to_anchor=(.5, -0.15), fancybox=True, ncol=2)
            ax.axis('equal')
        else:
            red_square = dict(markerfacecolor='r', marker='s')
            ax.boxplot(data, vert=False, flierprops=red_square)

        ax.set_title(f'{self.select.currentText()} for "{self.industry}"')
        self.canvas.draw()


class SimpleTableModel(QAbstractTableModel):
    def __init__(self, data: List[Dict[str, str]]):
        QAbstractTableModel.__init__(self, None)
        self.data = data
        self.headers = [k for k, v in data[0].items()]
        self.rows = [[v for k, v in record.items()] for record in data]

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


class SelectedDataDetail(QDialog):
    def __init__(self, row, industry_title):
        super(SelectedDataDetail, self).__init__()
        self.setWindowTitle("Selected Data Detail")
        beg_industry_code = str(row['industry_code'])
        if beg_industry_code[0:2] == '10':
            beg_industry_code = beg_industry_code[0:2]
        else:
            beg_industry_code = beg_industry_code[0]
        curs.execute(f'select own_title from own_titles where own_code = {row["own_code"]};')
        own_title = QLabel(list(curs.fetchone().values())[0])
        curs.execute(f'select agglvl_title from agglvl_titles where agglvl_code = {row["agglvl_code"]};')
        agglvl_title = QLabel(list(curs.fetchone().values())[0])
        row_info = [QLabel(str(row[i])) for i in row.keys()]

        form_group_box = QGroupBox('Selected Data Detail')
        layout = QFormLayout()
        layout.addRow(QLabel('ID:'), row_info[0])
        layout.addRow(QLabel('Ownership Code:'), row_info[1])
        layout.addRow(QLabel('Industry Code:'), row_info[2])
        layout.addRow(QLabel('Aggregate Level Code:'), row_info[3])
        layout.addRow(QLabel('Year:'), row_info[4])
        layout.addRow(QLabel('Ownership Title:'), own_title)
        layout.addRow(QLabel('Industry Title:'), QLabel(industry_title))
        layout.addRow(QLabel('Aggregate Level Title:'), agglvl_title)
        if len(row_info) == 10:
            layout.addRow(QLabel('Annual Average Establishments:'), row_info[6])
            layout.addRow(QLabel('Annual Average Weekly Wage:'), row_info[8])
            layout.addRow(QLabel('Average Annual Pay:'), row_info[9])
        elif len(row_info) == 13:
            layout.addRow(QLabel('Quarter:'), row_info[5])
            layout.addRow(QLabel('Quarterly Establishments:'), row_info[7])
            layout.addRow(QLabel('Average Weekly Wage:'), row_info[12])
        form_group_box.setLayout(layout)

        pic = QLabel(self)
        pixmap = QPixmap(f'{beg_industry_code}.jpg').scaled(400, 400, Qt.KeepAspectRatio, Qt.FastTransformation)
        pic.setPixmap(pixmap)
        pic.setAlignment(Qt.AlignCenter)

        ok = QDialogButtonBox(QDialogButtonBox.Ok)
        ok.accepted.connect(self.accept)

        vbox_layout = QVBoxLayout()
        vbox_layout.addWidget(form_group_box)
        vbox_layout.addWidget(pic)
        vbox_layout.addWidget(ok)
        self.setLayout(vbox_layout)


class ShowSelectedData(QDialog):
    def __init__(self, data, db, industry_title, extra_options):
        super(ShowSelectedData, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Selected Data")
        self.data = data
        self.db = db
        self.industry_title = industry_title
        self.extra_options = extra_options

        self.table_model = SimpleTableModel(data)
        self.table_view = QTableView()
        self.table_view.setModel(self.table_model)
        self.table_view.setSelectionMode(QAbstractItemView.SelectRows | QAbstractItemView.SingleSelection)

        self.year = QComboBox()
        self.year.addItems(['2016', '2017'])
        self.quarter = QComboBox()
        self.quarter.addItems(['1', '2', '3', '4', 'A'])
        self.industry = QLineEdit("Total, all industries")
        self.order = QComboBox()
        self.order.addItems(['None', 'Total quarterly wages ascending', 'Total quarterly wages descending',
                             'Average weekly wages ascending', 'Average weekly wages descending',
                             'Average annual pay ascending', 'Average annual pay descending',
                             'Average annual weekly wages ascending', 'Average annual weekly wages descending'])

        form_group_box = QGroupBox("Filter Selected Data")
        layout = QFormLayout()
        layout.addRow(QLabel("Year:"), self.year)
        layout.addRow(QLabel("Quarter:"), self.quarter)
        layout.addRow(QLabel("Industry:"), self.industry)
        layout.addRow(QLabel("Order By:"), self.order)
        form_group_box.setLayout(layout)

        self.filter = QPushButton('Filter')
        self.back = QPushButton('Back')
        self.detail = QPushButton('Detail')
        self.stat = QPushButton('See Data Statistics')

        self.filter.setEnabled(True)
        self.filter.pressed.connect(self.run_filter)
        self.industry.textChanged.connect(self.enable_filter)
        self.back.clicked.connect(self.run_back)
        self.detail.clicked.connect(self.run_detail)
        self.detail.setEnabled(False)
        self.table_view.clicked.connect(self.enable_detail)
        self.stat.clicked.connect(self.run_stat)

        vbox_layout = QVBoxLayout()
        vbox_layout.addWidget(form_group_box)
        vbox_layout.addWidget(self.filter)
        vbox_layout.addWidget(self.table_view)
        vbox_layout.addWidget(self.stat)
        vbox_layout.addWidget(self.back)
        vbox_layout.addWidget(self.detail)
        self.setLayout(vbox_layout)

    def run_filter(self):
        self.industry_title = self.industry.text()
        if curs.execute(f'select industry_code from industry_titles '
                        f'where industry_title = "{self.industry.text()}";') == 0:
            w = QMessageBox()
            QMessageBox.warning(w, "Invalid industry title", "Please enter a valid industry title.")
            w.show()
        elif (self.quarter.currentText() == 'A' and ('Total quarterly wages' in self.order.currentText() or
                                                     'Average weekly wages' in self.order.currentText())) or (
                self.quarter.currentText() != 'A' and ('Average annual pay' in self.order.currentText() or
                                                       'Average annual weekly wages' in self.order.currentText())):
            w = QMessageBox()
            error = 'The option you have selected for "Order By" does not work with what you have selected for ' \
                    '"Quarter". Please try again.'
            QMessageBox.warning(w, 'Invalid option for order by', error)
            w.show()
        else:
            if self.quarter.currentText() == 'A':
                self.extra_options = ['Average Annual Pay', 'Average Annual Weekly Wages',
                                      'Annual Average Establishments']
                self.table = 'combined_annuals'
                query = f'select * from combined_annuals where year = {self.year.currentText()} and industry_code in ' \
                    f'(select industry_code from industry_titles where industry_title = "{self.industry.text()}")'
                if 'Average annual pay' in self.order.currentText():
                    query += ' order by avg_annual_pay'
                elif 'Average annual weekly wages' in self.order.currentText():
                    query += ' order by annual_avg_wkly_wage'
            else:
                self.extra_options = ['Total Quarterly Wages', 'Average Weekly Wages']
                self.table = 'combined_quarters'
                query = f'select * from combined_quarters where year = {self.year.currentText()} and ' \
                    f'qtr = {self.quarter.currentText()} and industry_code in ' \
                    f'(select industry_code from industry_titles where industry_title = "{self.industry.text()}")'
                if 'Total quarterly wages' in self.order.currentText():
                    query += ' order by total_qtrly_wages'
                elif 'Average weekly wages' in self.order.currentText():
                    query += ' order by avg_wkly_wage'
            if 'descending' in self.order.currentText():
                query += ' desc'
            query += ';'
            if curs.execute(query) == 0:
                w = QMessageBox()
                QMessageBox.warning(w, "Query returns empty set", "Please try another combination.")
                w.show()
            else:
                self.close()
                self.display(self.db, query)

    def enable_filter(self):
        if len(self.industry.text()) > 0:
            self.filter.setEnabled(True)
        else:
            self.filter.setEnabled(False)

    def run_detail(self):
        current_index = self.table_view.currentIndex().row()
        selected_item = self.table_model.row(current_index)
        SelectedDataDetail(selected_item, self.industry_title).exec()

    def enable_detail(self):
        if self.table_view.currentIndex() == -1:
            self.detail.setEnabled(False)
        else:
            self.detail.setEnabled(True)

    def display(self, db, query):
        data = curs.fetchall()
        ssd = ShowSelectedData(data, db, self.industry.text(), self.extra_options)
        ssd.exec()

    def run_back(self):
        main_screen = MainWindow(login.db.text())
        self.close()
        main_screen.exec()

    def run_stat(self):
        stat_screen = DataStatistics(self.data, self.industry_title, self.extra_options)
        stat_screen.exec()


class MainWindow(QDialog):
    def __init__(self, db):
        super(MainWindow, self).__init__()
        self.setWindowTitle("BLS QCEW Database GUI")
        self.db = db
        self.extra_options = []

        self.year = QComboBox()
        self.year.addItems(['2016', '2017'])
        self.quarter = QComboBox()
        self.quarter.addItems(['1', '2', '3', '4', 'A'])
        self.industry = QLineEdit("Total, all industries")

        form_group_box = QGroupBox("BLS QCEW Database GUI")
        layout = QFormLayout()
        layout.addRow(QLabel("Year:"), self.year)
        layout.addRow(QLabel("Quarter:"), self.quarter)
        layout.addRow(QLabel("Industry:"), self.industry)
        form_group_box.setLayout(layout)

        self.button = QPushButton('Search')
        self.button.setEnabled(True)
        self.button.pressed.connect(self.run_button)
        self.industry.textChanged.connect(self.enable_button)

        self.vbox = QVBoxLayout()
        self.vbox.addWidget(form_group_box)
        self.vbox.addWidget(self.button)
        self.setLayout(self.vbox)

    def run_button(self):
        if curs.execute(f'select industry_code from industry_titles '
                        f'where industry_title = "{self.industry.text()}";') == 0:
            w = QMessageBox()
            QMessageBox.warning(w, "Invalid industry title", "Please enter a valid industry title")
            w.show()
        else:
            if self.quarter.currentText() == 'A':
                self.extra_options = ['Average Annual Pay', 'Average Annual Weekly Wages',
                                      'Annual Average Establishments']
                query = f'select * from combined_annuals where year = {self.year.currentText()} and industry_code in ' \
                    f'(select industry_code from industry_titles where industry_title = "{self.industry.text()}");'
            else:
                self.extra_options = ['Total Quarterly Wages', 'Average Weekly Wages']
                query = f'select * from combined_quarters where year = {self.year.currentText()} and ' \
                    f'qtr = {self.quarter.currentText()} and industry_code in ' \
                    f'(select industry_code from industry_titles where industry_title = "{self.industry.text()}");'
            if curs.execute(query) == 0:
                w = QMessageBox()
                QMessageBox.warning(w, "Query returns empty set", "Please try another combination")
                w.show()
            else:
                self.close()
                self.display(self.db, query)

    def enable_button(self):
        if len(self.industry.text()) > 0:
            self.button.setEnabled(True)
        else:
            self.button.setEnabled(False)

    def display(self, db, query):
        data = curs.fetchall()
        ssd = ShowSelectedData(data, db, self.industry.text(), self.extra_options)
        ssd.exec()


class DbLoginDialog(QDialog):
    def __init__(self):
        super(DbLoginDialog, self).__init__()
        self.setModal(True)
        self.setWindowTitle("Login to MySQL Server")

        self.host = QLineEdit("localhost")
        self.user = QLineEdit("root")
        self.password = QLineEdit()
        self.db = QLineEdit("blsqcew")

        form_group_box = QGroupBox("MySQL Server Login Credentials")
        layout = QFormLayout()
        layout.addRow(QLabel("Host:"), self.host)
        layout.addRow(QLabel("User:"), self.user)
        layout.addRow(QLabel("Password:"), self.password)
        layout.addRow(QLabel("Database:"), self.db)
        form_group_box.setLayout(layout)

        buttons = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)
        buttons.accepted.connect(self.accept)
        buttons.rejected.connect(self.reject)

        vbox_layout = QVBoxLayout()
        vbox_layout.addWidget(form_group_box)
        vbox_layout.addWidget(buttons)
        self.setLayout(vbox_layout)
        self.password.setFocus()


if __name__ == '__main__':
    app = QApplication(sys.argv)
    login = DbLoginDialog()
    if login.exec() == QDialog.Accepted:
        global connection
        try:
            connection = pymysql.connect(host=login.host.text(),
                                         user=login.user.text(),
                                         password=login.password.text(),
                                         db=login.db.text(),
                                         charset='utf8mb4',
                                         cursorclass=pymysql.cursors.DictCursor)
            curs = connection.cursor()
        except Exception as e:
            print(f"Couldn't log {login.user.text()} in to MySQL server on {login.host.text()}")
            print(e)
            qApp.quit()
            sys.exit()
        main = MainWindow(login.db.text())
        main.show()
        sys.exit(app.exec_())
    else:
        qApp.quit()
