import os
import pandas as pd

from tkinter import *
from tkinter import ttk 

cd = os.path.dirname(os.path.abspath(__file__))

df = pd.read_csv(os.path.join(cd, 'DATA', 'IncData.csv'))
df['YEARS'] = df['YEARS'].fillna('')

# GUI TABLE
class GUIapp():

    def __init__(self):
        self.root = Tk()
        self.buildControls()
        self.root.mainloop()

    def openTable(self):        
        self.SimpleTable()
                
    def buildControls(self):        
        self.root.wm_title("Report Menu")
        self.guiframe = Frame(self.root, width=2500, height=500, bd=1, relief=FLAT)
        self.guiframe.pack(padx=5, pady=5)

        # IMAGE
        self.photo = PhotoImage(file="IMG/IncDataIcon.png")
        self.imglbl = Label(self.guiframe, image=self.photo)
        self.imglbl.photo = self.photo
        self.imglbl.grid(row=0, sticky=W, padx=5, pady=5)
        self.imglbl = Label(self.guiframe, text="INC 5000 Company Reports", font=("Arial", 16)).\
                            grid(row=0, column=1, sticky=W, padx=5, pady=5)

        # INDUSTRY
        self.industrylbl = Label(self.guiframe, text="Industry", font=("Arial", 14)).grid(row=1, sticky=W, padx=5, pady=5)
        self.industryvar = StringVar()
        self.industrycbo = ttk.Combobox(self.guiframe, textvariable=self.industryvar, font=("Arial", 14), state='readonly')
        self.industrylist = [''] + [i for i in sorted(set(df['INDUSTRY'].tolist()))]
        self.industrycbo['values'] = self.industrylist              
        
        self.industrycbo.current(0)
        self.industrycbo.grid(row=1, column=1, sticky=W, padx=5, pady=5)

        # YEAR
        self.yearlbl = Label(self.guiframe, text="Year", font=("Arial", 14)).grid(row=2, sticky=W, padx=5, pady=5)
        self.yearvar = StringVar()
        self.yearcbo = ttk.Combobox(self.guiframe, textvariable=self.yearvar, font=("Arial", 14),state='readonly')
        self.yearlist = [''] + [str(i) for i in sorted(set(df['INC_YEAR'].tolist()))]
        self.yearcbo.grid(row=2, column=1, sticky=W, padx=5, pady=5)
        self.yearcbo['values'] = self.yearlist
        
        # METRO
        self.metrolbl = Label(self.guiframe, text="Metro", font=("Arial", 14)).grid(row=3, sticky=W, padx=5, pady=5)
        self.metrovar = StringVar()
        self.metrocbo = ttk.Combobox(self.guiframe, textvariable=self.metrovar, font=("Arial", 14),state='readonly')
        self.metrolist = [''] + [str(i) for i in set(df['METRO_AREA'].tolist())]
        self.metrolist = sorted(self.metrolist)
        self.metrocbo.grid(row=3, column=1, sticky=W, padx=5, pady=5)
        self.metrocbo['values'] = self.metrolist     

        # OPEN TABLE BUTTON 
        self.btnoutput = Button(self.guiframe, text="Open Table", font=("Arial", 10), width=25, command=self.openTable).\
                                grid(row=8, column=1, sticky=W, padx=10, pady=5)
        
    def SimpleTable(self):
        # GET COMBO BOX VALUES
        industry = self.industrycbo.get()
        incyear = [None if self.yearcbo.get()=='' else int(self.yearcbo.get())][0]
        metro = self.metrocbo.get()

        # CONDITIONAL FILTERS
        df_filter = (df.index >= 0)        
        if industry != "": df_filter = df_filter & (df['INDUSTRY']==industry)
        if incyear is not None: df_filter = df_filter & (df['INC_YEAR']==incyear)
        if metro != "": df_filter = df_filter & (df['METRO_AREA']==metro)
            
        tempdf = df[df_filter].reset_index()

        # INITIALIZE NEW WINDOW FRAME
        self.tbl = Tk()
        self.canvas = Canvas(self.tbl, width=1200, height=500)
        
        self.tbl.wm_title("Output Table")
        rows = len(tempdf)
        columns = len(tempdf.columns)
        
        self.tblFrame = Frame(self.canvas, background="black", bd=1, relief=FLAT)
        
        self.tblScrollbar = Scrollbar(self.tbl, orient="vertical", command=self.canvas.yview)
        self.canvas.configure(yscrollcommand = self.tblScrollbar.set)

        self.tblScrollbar.pack(side="right", fill="y")        
        self.canvas.pack(side="left", fill="both", expand=True)        
        self.canvas.create_window((4,4), window=self.tblFrame, anchor="nw", tags="self.frame")
        self.tblFrame.bind("<Configure>", self.onFrameConfigure)
        
        self.tblFrame._widgets = []
        
        # HEADERS
        current_row = []
        for column in range(1,columns):
            label = Label(self.tblFrame, font=("Arial", 10), text=' '+tempdf.columns[column]+' ',
                          borderwidth=0)
            label.grid(row=0, column=column, sticky="nsew", padx=1, pady=1)
            current_row.append(label)
        self.tblFrame._widgets.append(current_row)
        

         # DATA ROWS   
        for row in range(1,rows+1):
            current_row = []
            for column in range(1,columns):
                label = Label(self.tblFrame, font=("Arial", 10), text=tempdf.ix[row-1,column], 
                              borderwidth=0)
                label.grid(row=row, column=column, sticky="nsew", padx=1, pady=1)
                current_row.append(label)
            self.tblFrame._widgets.append(current_row)

        for column in range(1,columns):
            self.tblFrame.grid_columnconfigure(column, weight=1)

        def set(tbl, row, column, value):
            widget = self.tblFrame._widgets[row][column]
            widget.configure(text=value)

    def onFrameConfigure(self, event):
        '''Reset the scroll region to encompass the inner frame'''
        self.canvas.configure(scrollregion=self.canvas.bbox("all"))
        
GUIapp()
