## Source global.R file
## This file must be in the same directory as your ui.R and server.R files
source("global.R")


## Build user interface (how your app looks)
shinyUI(
  fluidPage(theme="sandstone.css", # This .css file is located in your 'www' folder. There are many options to choose from. 
                               # A selection of css themes are in your 'www' folder, try calling different .css files in
                               # to play with the look of your app.
            navbarPage("Name of App you want on the top of the Navigation Pane",
                       tabPanel("About",
                                h1("You don't need this section of the app, but I like to include it to give context
                                   to users before they use the app."),
                                h2("This also allows the server a moment to load in necessary data to use the app."),
                                h3("That slight pause is especially important if you are reading in many shapefiles to
                                   said app because they take a moment to load."),
                                h4("Example Text:
                                   'This app is a data viewer for the XXXXXX TMDL public meeting' on XX-XX-2017'"),
                                h5("The font is getting smaller because I am using a new header line each time I begin
                                   text. These headers are called by using the h1(), h2(),h3(), etc. calls. h6() is the 
                                   smallest header text you can apply."),
                                h6("h6() looks like this."),
                                p("You can also include a paragraph text input for longer strings you wish to display.
                                  That is called by wrapping your text in p()"),
                                helpText("The helpText() wrapper is useful as well, note how it changes the font style."),
                                hr(),
                                p("To insert a line break you call hr() . For a break without a line use br() . That style can 
                                  be seen below."),
                                p("You can also change the font of strings in headers or paragraphs",
                                  strong("by adding strong() as a wrapper around text strings"),"within your p() or hX() call.",
                                  span("Using span() around text strings allows you to block out certain sections of text to 
                                       change the font ",strong("style/color"),"as you need to draw emphasis.",style="color:blue")),
                                br(),
                                p("Directly above this line is a break, denoted to the ui by calling br() ."),
                                br(),
                                p("Insert images into your app (after saving them as a .png or .jpg inside a folder named 'www') 
                                  by using the img() call."),
                                fluidRow(
                                  column(6,
                                         column(4,
                                                p("These fish are plotted next to eachother (vs on different lines) because of a 
                                                  column() call.")),
                                         img(src="fish.jpg", height=100,width=100),
                                         img(src="grayfish.png", height=40,width=100))),
                                fluidRow(column(12,
                                                span("You can adjust the placement of text/images within your app by wrapping sections in a
                                                  column() call. The first argument is a number 1-12 that will divide up your user's screen
                                                  into sections, read: widths, that automatically adjust to their screen resolution (",
                                                     strong("how cool is that?"),") based on how you design the app. This panel is 12 
                                                     (maximum width)."))),
                                fluidRow(column(1,p("I'm in column(1, XXXX) here.")),
                                         column(3,p("I'm in column(3, XXXX) here.")),
                                         column(4,p("I'm in column(4, XXXX) here.")),
                                         column(4,p("I'm in column(4, XXXX) here.")),
                                         column(8,p("I'm in column(8,XXXX) here because I exceeded the total width measure (12)."))),
                                fluidRow(column(10,
                                                wellPanel(
                                                  p("I'm in a new fluidRow() in a wellPanel() in column(10, XXX) here."),
                                                  p("Note how wide 10 looks and how it scales if you adjust the width of your window.")))),
                                br(),
                                br(),
                                hr(),  
                                h1("Lastly,",span(strong("ALWAYS"),style="color:red"),"use a comma at the end of every call in your
                                   ui.R script. Otherwise, your app will crash.")
                                ),
                       tabPanel("Map",
                                bootstrapPage(div(class="outer",
                                                  tags$style(type ="text/css",".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"),
                                                  leafletOutput("firstMap", width="100%", height="100%"),
                                                  absolutePanel(top=60,right=10, class="panel panel-default", width=350, height="auto", draggable = TRUE,
                                                                h3("Legend"), 
                                                                checkboxInput("polygon1_", "Click here to turn on polygon1 shapefile"),
                                                                checkboxInput("polygon2_", "Click here to turn on polygon2 shapefile"),
                                                                checkboxInput("polyline1", "Click here to turn on polyline1 shapefile"),
                                                                checkboxInput("pointfile1", "Click here to turn on pointfile1 shapefile"),
                                                                plotOutput("scatter", height=200)),
                                                  verbatimTextOutput("click_text")
                                ))),
                       tabPanel("Table", 
                                tableOutput("table1"))
            )
  )
) # Always make sure you close your ui