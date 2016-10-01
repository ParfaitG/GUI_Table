
import java.util.*;
import java.net.URI;
import java.net.URISyntaxException;

import java.io.File;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

import java.awt.*;
import java.awt.event.*;

import javax.swing.*;
import javax.swing.event.*;

public class GUI_Table_JAVA extends Frame
    implements WindowListener {
    
    public GUI_Table_JAVA (ArrayList<String[]> incdata) {
		
	    // SUPER FRAME SETTINGS
	    JFrame formframe = new JFrame();
	    
	    formframe.setTitle("Report Menu");    
	    formframe.setSize(600, 250);
	    JPanel guipanel = new JPanel(new GridBagLayout());
	    GridBagConstraints c = new GridBagConstraints();
	    formframe.add(guipanel);
		  
	    Font ctrlFont = new Font("Arial", Font.PLAIN, 16);
	    Font headFont = ctrlFont.deriveFont(24F);
		  
	    // IMAGE      
	    ImageIcon image = new ImageIcon("IMG/IncDataIcon.png");
	    JLabel imagelabel = new JLabel("", image, JLabel.LEFT);      
	    c.fill = GridBagConstraints.HORIZONTAL;
	    c.ipady = 0; 
	    c.weighty = 0.05;      
	    c.gridx = 0;
	    c.gridy = 0;
	    guipanel.add(imagelabel, c);
      
	    JLabel imglbl = new JLabel("INC 5000 Company Reports", SwingConstants.CENTER);      
	    imglbl.setFont(headFont);      
	    c.fill = GridBagConstraints.HORIZONTAL;
	    c.ipady = 0; 
	    c.weighty = 0.05;      
	    c.gridx = 1;
	    c.gridy = 0;
	    guipanel.add(imglbl, c);
	    
	    // INDUSTRY
	    JLabel industrylbl = new JLabel("Industry   ", SwingConstants.LEFT);
	    industrylbl.setFont(ctrlFont);
	    c.fill = GridBagConstraints.HORIZONTAL;
	    c.ipady = 0; 
	    c.weighty = 0.05;      
	    c.gridx = 0;
	    c.gridy = 1;
	    guipanel.add(industrylbl, c);
	    
	    Choice industryChoice = new Choice();
	    industryChoice.setFont(ctrlFont);	    
	    c.fill = GridBagConstraints.HORIZONTAL;
	    c.ipady = 0; 
	    c.weighty = 0.05;      
	    c.gridx = 1;
	    c.gridy = 1;
	    guipanel.add(industryChoice, c);
	    
	    // INDUSTRY ITEMS
	    ArrayList<String> industrylist = new ArrayList<String>();
	    Set<String> hs = new HashSet<>();
	    for (String[]item: incdata){
		if (item.length > 5) {
		    industrylist.add(item[5]);
		}
	    } 	    
	    
	    hs.addAll(industrylist);
	    hs.add("");
	    industrylist.clear();	    
	    industrylist.addAll(hs);
	    Collections.sort(industrylist);
	    for (String ind: industrylist){		
		industryChoice.add(ind);		
	    }  
	    
	    // YEAR           
	    JLabel yearlbl= new JLabel("Year", SwingConstants.LEFT);
	    yearlbl.setFont(ctrlFont);
	    c.fill = GridBagConstraints.HORIZONTAL;
	    c.ipady = 0; 
	    c.weighty = 0.05;      
	    c.gridx = 0;
	    c.gridy = 2;
	    guipanel.add(yearlbl, c);                            
	    
	    Choice yearChoice = new Choice();
	    yearChoice.setFont(ctrlFont);
	    c.fill = GridBagConstraints.HORIZONTAL;
	    c.ipady = 0; 
	    c.weighty = 0.05;
	    c.gridx = 1;
	    c.gridy = 2;
	    guipanel.add(yearChoice, c);		
		
	    // YEAR ITEMS
	    ArrayList<String> yearlist = new ArrayList<String>();
	    hs = new HashSet<>();
	    for (String[] item: incdata){
		if (item.length > 1) {
		    yearlist.add(item[1]);
		}
	    } 
		    
	    hs.addAll(yearlist);
	    hs.add("");
	    yearlist.clear();
	    yearlist.addAll(hs);
	    Collections.sort(yearlist);		   
	    for (String y: yearlist){		
		yearChoice.add(y);		
	    }  
	    
	    // METRO          
	    JLabel metrolbl= new JLabel("Metro", SwingConstants.LEFT);
	    metrolbl.setFont(ctrlFont);
	    c.fill = GridBagConstraints.HORIZONTAL;
	    c.ipady = 0; 
	    c.weighty = 0.05;      
	    c.gridx = 0;
	    c.gridy = 3;
	    guipanel.add(metrolbl, c);                            
	    
	    Choice metroChoice = new Choice();
	    metroChoice.setFont(ctrlFont);
	    c.fill = GridBagConstraints.HORIZONTAL;
	    c.ipady = 0; 
	    c.weighty = 0.05;
	    c.gridx = 1;
	    c.gridy = 3;
	    guipanel.add(metroChoice, c);		
		
	    // METRO ITEMS
	    ArrayList<String> metrolist = new ArrayList<String>();
	    hs = new HashSet<>();
	    for (String[] item: incdata){
		if (item.length > 7) {
		    metrolist.add(item[7]);
		}
	    } 
		    
	    hs.addAll(metrolist);
	    hs.add("");
	    metrolist.clear();
	    metrolist.addAll(hs);
	    Collections.sort(metrolist);
		   
	    for (String d: metrolist){	     
	       metroChoice.add(d);
	    }
	    
	    // BUTTON
	    JLabel btnlbl = new JLabel("", SwingConstants.LEFT);
	    btnlbl.setFont(ctrlFont);
	    c.fill = GridBagConstraints.HORIZONTAL;
	    c.ipady = 0; 
	    c.weighty = 0.05;
	    c.gridx = 0;
	    c.gridy = 4;      
	    guipanel.add(btnlbl, c);
	    
	    Button btnOutput = new Button("Output Table");
	    btnOutput.setFont(ctrlFont);
	    c.fill = GridBagConstraints.HORIZONTAL;
	    c.ipady = 0; 
	    c.weighty = 0.05;
	    c.insets = new Insets(0,0,10,0);
	    c.gridx = 1;
	    c.gridy = 4;         
	    guipanel.add(btnOutput, c);
	    
	    btnOutput.addActionListener(new ActionListener(){
		
		public void actionPerformed(ActionEvent ae){
		    //Object[][] tbldata = new Object[100][8];
		    ArrayList<String[]> tbldata = new ArrayList<String[]>();
		    
		    String[] headers = {"Rank", "Inc Year", "Company", "Three-Yr Growth", "Revenue", "Industry", "Years", "Metro Area"};

		    int k = 0; int m = 0;		    
		    		    
		    for( String[] linedata: incdata ){
			if (linedata.length > 7) {			    
			    
			    Boolean condition = true;
			    if (!industryChoice.getSelectedItem().toString().equals("")){  
				condition = condition && linedata[5].equals(industryChoice.getSelectedItem().toString());
			    }
			    if (!yearChoice.getSelectedItem().toString().equals("")){  
				condition = condition && linedata[1].equals(yearChoice.getSelectedItem().toString());
			    }
			    if (!metroChoice.getSelectedItem().toString().equals("")){  
				condition = condition && linedata[7].equals(metroChoice.getSelectedItem().toString());
			    }
	    
			    if (condition) {
				tbldata.add(linedata);
				k++;			    
			    }
			}
		    }
		    		    
		    Object[][] framedata = new Object[tbldata.size()][8];
		    for (int t=0; t < tbldata.size(); t++){			
			framedata[t] = tbldata.get(t);
		    }
		    		    
		    JFrame tableframe = new JFrame();
		    
		    tableframe.setTitle("Output Table");
		    tableframe.setSize(1225, 450);	
		    JTable IncTable = new JTable(framedata, headers);
		    JScrollPane scrollpane = new JScrollPane(IncTable);
		    tableframe.add(scrollpane);
		    
		    tableframe.setVisible(true);
		    
		    IncTable.getSelectionModel().addListSelectionListener(new ListSelectionListener() {		
			public void valueChanged(ListSelectionEvent event) {
			    if ((IncTable.getSelectedRow() > -1) & (event.getValueIsAdjusting())) {				
				String company = IncTable.getValueAt(IncTable.getSelectedRow(), 2).toString();
				if(Desktop.isDesktopSupported()) {
				    try {
					Desktop.getDesktop().browse(new URI("http://www.google.com/#q="+ company.replace(" ", "%20")));
				    } catch (URISyntaxException ure) {
					System.out.println(ure.getMessage());
				    } catch (IOException ioe) {
					System.out.println(ioe.getMessage());
				    }
				}				
			    }
			}
		    });
		}
	    });

	    
	    formframe.addWindowListener(this);     
	    formframe.setVisible(true);
	    	    
    }
   
    public static void main(String[] args) {    
    
	try {
	    ArrayList<String[]> incdata = new ArrayList<String[]>();
	    String currentDir = new File("").getAbsolutePath();
	    String csv = currentDir + "\\Data\\IncData.csv";
    
	    BufferedReader br = null;
	    String line = "";
	    String csvSplitBy = "\",\"";
			
	    br = new BufferedReader(new FileReader(csv));		    		    
	    
	    int j = 0;
	    while ((line = br.readLine()) != null) {
		
		if (j==0){ j++; continue; }			    
		
		line = line.substring(1, line.length() - 1);
		String[] linedata = line.split(csvSplitBy);
		String str = "";			
		incdata.add(linedata);
	    }			    
	    new GUI_Table_JAVA(incdata);
	    
	} catch (FileNotFoundException ffe) {
	    System.out.println(ffe.getMessage());
	} catch (IOException ioe) {
	    System.out.println(ioe.getMessage());
	}
    }
    
    // WindowEvent handlers
    @Override
    public void windowClosing(WindowEvent evt) {
	// Terminate the program
	System.exit(0);                                                          
    }
   
    @Override public void windowOpened(WindowEvent evt) { }
    @Override public void windowClosed(WindowEvent evt) { }
    @Override public void windowIconified(WindowEvent evt) { }
    @Override public void windowDeiconified(WindowEvent evt) { }
    @Override public void windowActivated(WindowEvent evt) { }
    @Override public void windowDeactivated(WindowEvent evt) { }

}