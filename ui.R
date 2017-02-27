# Surplus scout

# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# This app should be used to elucidate the surplus land of Schools
# based on PDS data and Google Earth like mapping
# and determine where there is potential for building
# additional capacity in relation to School Capacity and Planning data by LA

library(shiny)
library(leaflet)


# FANCY STYLE -------------------------------------------------------------

ui <- navbarPage("Cherry picker", id = "nav",
                 
           tabPanel("Interactive map",
                    
                    # div(class = "outer",
                    #     
                        tags$head(
                          # Include our custom CSS
                          includeCSS("styles.css")
                        ),
                        leafletOutput("mymap"), 
                    br(),
                    p("We code for the radius of the circle of apples of each school to be proportional (1:1 scale)
                      to the one hundred times the apples at the school.", 
                      br(),
"This allows the user to inspect the actual map and sense check using the Terrain map tile,
                      as often the boundaries of the school and playing field areas are included on the map.",
br(),
"Importantly ", strong("playing fields are considered surplus land;"), " only land with school buildings do not contribute
                      to surplus land.", 
                      style = "font-family: 'times'; font-si16pt"),
                    
                        # Shiny versions prior to 0.11 should use class="modal" instead.

                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = "auto", right = 180, bottom = "auto",
                                      width = 330,
                                      height = "auto",
                                      h4("User input"),
                                      selectInput(inputId = "la_of_interest", label = "Local Authority",
                                                  choices = la_user_friendly_list, selected = "202 - Camden"),
                                      selectInput(inputId = "phase", label = "School phase",
                                                  choices = c("Secondary", "Primary")),
                                      plotOutput("hist_no_pupils_in_excess", height = 200),
                                      plotOutput("pupil_excess_as_percentage_of_places", height = 200),
                                      p("Here we provide School Capacity and Planning data distributions for all 152 LA for schools of the same phase in England. 
                                        To facilitate comparison the selected LA's relevant datum is represented by a blue tick below the x-axis.")
                                      )
                                      
                                      
                        ),
           
tabPanel("Data explorer", div(h3("Schools' details for the Local Authority of ", textOutput("la_name"))),
         br(),
         DT::dataTableOutput("surplus_table_data"),
         br(),
         h4("Table variables explained"),
         p("The area measurements are estimates in metres squared.
           The ", strong("surplus_land"), "is estimated by the ", strong("total_site_area"), "minus the ", strong("total_ground_floor"), "area, thus this includes a School's Playing Field area.",
           "The ", strong("surplus_proportion"),  " is calculated by the ", strong("surplus_land"), " divided by the ", strong("surplus_land"), " plus the ", strong("total_ground_floor"), " area.",
           "This statistic (", strong("surplus_proportion") , ") provides a relative measure of the amount of free land on a school and helps compare between schools of different sizes (with 1 implying no school buildings and all free land and 0 vice versa).",
           style = "font-family: 'times'; font-si16pt"),
         downloadButton("download_data", "Download"),
         br(),
         p("ISSUE: Following file download you may have to restart the app.", 
           style = "font-family: 'times'; font-si16pt")
         ),

tabPanel("Forms of entry (FE) limit",
         h4("Schools selected from Data explorer tab"),
         DT::dataTableOutput("form_of_entry"),
         h4("How many forms of entry can fit given the surplus land?"),
         p("Click on your schools of interest in the previous panel.",
           "The area of land required for each form of entry is based on the recommended area per pupil at the relevant school phase.",
           "Thus the surplus land of the school is divided by this value for one through to five Forms of Entry.",
           style = "font-family: 'times'; font-si16pt")
         ),


tabPanel("Data and methods",
         h3("Data origin"),
         p("This app combines data from various sources. Inspect the App data folder for  the .csv files",
           style = "font-family: 'times'; font-si16pt"), 
         br(),
         h4("Mapping"),
         p("The linking of Secondary Schools' in England
         data was achieved using their Unique Reference Number (URN). The location of each School was provided by ",
           a(href = "http://www.education.gov.uk/edubase/home.xhtml", "Edubase."),
           "See the file 00_get_school_location_sql.R for the R/SQL code to query Edubase SQL data table.",
           style = "font-family: 'times'; font-si16pt"),
         br(),
         h4("SCAP"),
         p("The School Capacity and Planning Data was provided by ",
           a(href = "https://www.google.co.uk", "Adam Bray"),
           "It is the 2015 data.",
           style = "font-family: 'times'; font-si16pt"),
         br(),
         h4("School Surplus Land data"),
         p("The School area data was queried using R/SQL from the 2012-2014 ",
           a(href = "https://www.gov.uk/government/publications/property-data-survey-programme",
             "Property Data Survey (PDS) data tables." ),
           style = "font-family: 'times'; font-si16pt"),
         br(),
         h4("Complete cases"),
         p("Only complete cases were used,
           i.e. where a School had corresponding PDS, SCAP and mapping data.",
           style = "font-family: 'times'; font-si16pt"),
         br()),
###
img(src = "mg_logo.png", height = 144, width = 144),
br(),
tags$div(id = "cite",
         'App developed by ',
         a(href = "https://github.com/mammykins/App-cherry_picker", "Dr Matthew Gregory"), "."
), 
tags$blockquote("Correlation does not imply causation.", cite = "Anon.")


         
)