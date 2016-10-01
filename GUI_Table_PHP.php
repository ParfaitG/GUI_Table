<?php

function csvData() {
    $cd = dirname(__FILE__);
    $handle = fopen($cd."/DATA/IncData.csv", "r");    
    
    $csvdata = [];
    $row = 0;
    
    while (($data = fgetcsv($handle, 1000, ',')) !== FALSE) {
        $inner = [];
        if ($data[0] == 'RANK') { continue; }
        
        $csvdata[] = $data;
        $row++;
    }
        
    return($csvdata);
}


class mainWindow extends GtkWindow {    
    
    function __construct($incdata, $parent = null) {
        parent::__construct();
                
        $this->set_title('Report Menu');
        $this->connect_simple('destroy', array( 'Gtk', 'main_quit'));
        $this->set_size_request(450,250);
        
        $tbl = new GtkTable(9, 2);        
        $this->add($tbl);
        
        // IMAGE
        $img = GtkImage::new_from_file('IMG/IncDataIcon.png');
        $tbl->attach($img, 0, 1, 0, 1);
        
        $menulbl = new GtkLabel('INC 5000 Company Reports');
        $menulbl->modify_font(new PangoFontDescription('Arial 14'));
        $tbl->attach($menulbl, 1, 2, 0, 1);
        
        // INDUSTRY
        $industrylbl = new GtkLabel('Industry');
        $industrylbl->modify_font(new PangoFontDescription('Arial 14'));
        $industryalign = new GtkAlignment(0.25, 0.5, 0, 0);
        $industryalign->add($industrylbl);
        $tbl->attach($industryalign, 0, 1, 1, 2);
        
        $industry = [''];
        $industrycbo = GtkComboBox::new_text();        
        foreach ($incdata as $item){
            $industry[] = $item[5];
        }
        $industry = array_unique($industry);
        sort($industry);
        
        foreach($industry as $i){
            $industrycbo->append_text($i);
        }
        
        $tbl->attach($industrycbo, 1, 2, 1, 2);
        
        // YEAR
        $yearlbl = new GtkLabel('Year');
        $yearlbl->modify_font(new PangoFontDescription('Arial 14'));
        $yearalign = new GtkAlignment(0.25, 0.5, 0, 0);
        $yearalign->add($yearlbl);
        $tbl->attach($yearalign, 0, 1, 2, 3);
        
        $years = [''];
        $yearcbo = GtkComboBox::new_text();        
        foreach ($incdata as $item){
            $years[] = (string)$item[1];
        }        
        $years = array_unique($years);
        sort($years);
        
        foreach($years as $y){
            $yearcbo->append_text($y);
        }
        
        $tbl->attach($yearcbo, 1, 2, 2, 3);
        
        // METRO
        $metrolbl = new GtkLabel('Metro');
        $metrolbl->modify_font(new PangoFontDescription('Arial 14'));
        $metroalign = new GtkAlignment(0.25, 0.5, 0, 0);
        $metroalign->add($metrolbl);
        $tbl->attach($metroalign, 0, 1, 3, 4);
        
        $metros = [];
        $metrocbo = GtkComboBox::new_text();        
        foreach ($incdata as $item){
            $metros[] = $item[7];
        }        
        $metros = array_unique($metros);
        sort($metros);  
        
        foreach($metros as $m){            
            $metrocbo->append_text($m);
        }
        
        $tbl->attach($metrocbo, 1, 2, 3, 4);
        
        // BUTTON OUTPUT
        $btnOutput = new GtkButton('Output Table');
        $tbl->attach($btnOutput, 1, 2, 4, 5);
        
        $btnOutput->connect('clicked', array($this, 'signal_clicked'), $incdata, $industrycbo, $yearcbo, $metrocbo);
       
        $this->show_all();
    }        
        
    function signal_clicked($btnOutput, $incdata, $industrycbo, $yearcbo, $metrocbo) {
        
        $window = new GtkWindow();
        $srcllwindow = new GtkScrolledWindow();
        $window->add($srcllwindow);
        
        $window->set_title('Output Table');
        $window->connect_simple('destroy', array( 'Gtk', 'main_quit'));        
                
        $tbl = new GtkTable(500, 9);                        
                
        $headers = array("RANK", "INC_YEAR", "COMPANY", "3-YR GROWTH", "REVENUE", "INDUSTRY", "YEARS", "METRO_AREA");
        array_unshift($incdata, $headers);
        
        $model = $industrycbo->get_model();
        if ($industrycbo->get_active_iter() != null){
            $indselection = $model->get_value($industrycbo->get_active_iter(), 0);
        }
        
        $model = $yearcbo->get_model();
        if ($yearcbo->get_active_iter() != null){
            $yrselection = $model->get_value($yearcbo->get_active_iter(), 0);
        }
        
	$model = $metrocbo->get_model();
        if ($metrocbo->get_active_iter() != null){
            $metroselection = $model->get_value($metrocbo->get_active_iter(), 0);
        }

        $row = 0;
        foreach($incdata as $item){
                        
            $filter = true;
            
            if ($indselection != "") {                
                $filter = $filter && $item[5] == $indselection;
            }
            
            if ($yrselection != "") {                
                $filter = $filter && $item[1] == $yrselection;
            }
            
            if ($metroselection != "") {                
                $filter = $filter && $item[7] == $metroselection;
            }            
            
            if ($row == 0 || ($filter)){                
                
                $lbl1 = new GtkLabel($item[0]);
                $lbl1->modify_font(new PangoFontDescription('Arial 10'));                
                $tbl->attach($lbl1, 0, 1, $row, $row+1);
                                
                $lbl2 = new GtkLabel($item[1]);
                $lbl2->modify_font(new PangoFontDescription('Arial 10'));                
                $tbl->attach($lbl2, 1, 2, $row, $row+1);
                
                $lbl3 = new GtkLabel($item[2]);
                $lbl3->modify_font(new PangoFontDescription('Arial 10'));                
                $tbl->attach($lbl3, 2, 3, $row, $row+1);
                
                $lbl4 = new GtkLabel($item[3]);
                $lbl4->modify_font(new PangoFontDescription('Arial 10'));                         
                $tbl->attach($lbl4, 3, 4, $row, $row+1);
                                
                $lbl5 = new GtkLabel($item[4]);
                $lbl5->modify_font(new PangoFontDescription('Arial 10'));                     
                $tbl->attach($lbl5, 4, 5, $row, $row+1);
                     
                $lbl6 = new GtkLabel($item[5]);           
                $lbl6->modify_font(new PangoFontDescription('Arial 10'));                
                $tbl->attach($lbl6, 5, 6, $row, $row+1);
                                
                $lbl7 = new GtkLabel($item[6]);
                $lbl7->modify_font(new PangoFontDescription('Arial 10'));                     
                $tbl->attach($lbl7, 6, 7, $row, $row+1);
                                
                $lbl8 = new GtkLabel($item[7]);
                $lbl8->modify_font(new PangoFontDescription('Arial 10'));                
                $tbl->attach($lbl8, 7, 8, $row, $row+1);
                
                $row++;                
            }
            
        }
        
        if ($row < 8) {
            $window->set_size_request(1050,29*$row);
        } else {
            $window->set_size_request(1050,450);
        }        
        
        $srcllwindow->add_with_viewport($tbl);        
        $tbl->set_focus_vadjustment($srcllwindow->get_vadjustment());
                
        $window->show_all();
            
    }
    
}

$incData = csvData();
new mainWindow($incData);
Gtk::main();

?>