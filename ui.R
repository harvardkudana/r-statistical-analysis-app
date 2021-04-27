library(shiny)
library(shinythemes)
library(ggplot2)

fluidPage(theme = shinytheme("darkly"),
  mainPanel(
    tabsetPanel(
      tabPanel(align = 'center',
        "Introduction",
        br(),
        h4("The Volatile Exchange Rate Problem"),
        br(),
        uiOutput("hyperinflation"),
        br(),
        h4("Problem Statement"),
        br(),
        p("One of the claims brought up when it comes to foreign direct investment in
          third world countries is the volatility of African economies, people claim
          that it is difficult to predict the financial trajectory of less economically
          developed African countries, and the risk presented to the investor is too high to
          make a commitment, reducing the amount of capital which could potentially enter
          African markets"),
        br(),
        h4("My Hypothesis"),
        br(),
        p("I hypothesise that 4 variables related to the performance and state of
          African economies can be used to predict how that country's currency is doing
          with respect to the United States"),
        br(),
        h4("Why It Matters"),
        br(),
        p("I believe that if I am able to successfully able to predict the exchange rate
          of a country given particular variables, I could use the adjustment of those
          variables to help potential investors looking at Africa mitigate their risk,
          improving overall investment and the amount of capital in the country.")
      ),
      tabPanel(
        "Variables",
        h3("Africa Recession Modelling Dataset"),
        p(
          "The dataset used in this app is the ",
          a(href = "https://www.kaggle.com/chirin/african-country-recession-dataset-2000-to-2017",
            "African Country Recession Dataset"),
          "which combines information from the World Bank's GDP dataset, the Bank 
          of Canada's Commodity Indices and the University of Gronigen's Penn World 
          Table Productivity dataset. The time period covered in this dataset is the
          year 2000 to the year 2017, and there are 27 African countries sampled, including
          Morroco, South Africa, Tanzania, Rwanda, Eswatini, Togo, Burkina Faso, Angola, Tunisia,
          Nigeria, Kenya, Burundi, Benin, Namibia, Central African Republic, Sudan, Gabon, Niger,
          Sierra Leone, Lesotho, Mauritania, Senegal, Mauritius, Botswana, Cameroon, Mozambique and
          of course Zimbabwe."
        ),
        h3("Measurement of Variables"),
        h4("Outcome Variable: xr"),
        p("Exchange rate, national currency/USD (market+estimated). The exchange
          rate of an African country with respect to the US Dollar."),
        br(),
        h4("Distribution of xr - Exchange Rate"),
        plotOutput("measurementxr"),
        br(),
        h4("Explanatory Variable: hc"),
        p("Human capital index, based on years of schooling and returns to education.
          Derived and taken from the Bank of Canada"),
        br(),
        h4("Distribution of hc - Human Capital Index"),
        plotOutput("measurementhc"),
        h4("Distribution of growthbucket - Recession"),
        plotOutput("measurementrecession")
      ),
      tabPanel(
        "Bivariate Relationship",
        h3("Bivariate Relationship"),
        p("Since exchange rate and human capital index are both measured at the 
          interval level, we can quanitfy the strength and the direction of the linear
          association between the two variables using a Pearson's correlation coefficient,
          and we can visualize their bivariate relationship using a scatter plot"),
        h4("Pearson's Coefficient"),
        textOutput("pearsoncoefficient"),
        h4("Interpretation of Coefficient"),
        p("There is a small magnitude negative correlation between human capital
          index and exchange rate. What this means is that the relationship between
          these two variables is negative and relatively weak. We do expect to see
          an increase in the human capital index of an African country correspond to
          a decrease in the exchange rate, however we do not expect that change to be too extreme."),
        h4("Scatter Plot Diagram"),
        plotOutput("bivariate"), 
        h4("Interpretation of Scatter Plot Diagram"),
        p("As the human capital index of african countries increases, the exchange
          rate decreases. However, from the large number of outlier points in the
          diagram, I hypothesise that more variables are significant predictors of
          exchange rate outside of just human capital index For this reason, I decided
          to test the relationship between exchange rate and two other variables. Additionally, 
          we may need to run a hypothesis test to confirm if human capital index really has
          a statistically significant relationship with the exchange rate of the country
          (see hypothesis tests for correlation in the following tab)")
      ),
      tabPanel(
        "Hypothesis Test",
        h3("Hypothesis Test for Correlation"),
        h4("Null Hypothesis"),
        withMathJax("$$H_0: \\rho = 0$$"),
        p("The null hypothesis is that the population correlation is zero, which
          means that there is no linear relationship between human capital index
          and the exchange rate of an African country."),
        h4("Alternative Hypothesis"),
        withMathJax("$$H_A: \\rho \\not = 0$$"),
        p("The alternative hypothesis is that the population correlation is not
          zero, which means that there is a linear relationship between human capital
          index and the exchange rate of a country."),
        h4("Test Statistic"),
        withMathJax("$$t = \\frac{r \\sqrt{n-2}}{\\sqrt{1-r^2}}$$"),
        p("Above is the equation to calculate the test statistic of our hypothesis,
          where r is the estimated correlation coefficient and n is the size of the
          sample."),
        withMathJax("$$t-statistic = -6.5586$$"),
        h4("P-Value"),
        withMathJax("$$p-value = 1.397 * 10^{-10}$$"),
        h4("Interpretation"),
        tags$ul(
          tags$li("t statistic: The absolute value of the t-statistic is 6.5586,
                  which is greater than 1.96"),
          tags$li("p-value: The p-value is 1.397e-10, which is less than 0.05"),
          tags$li("Confidence Interval: The 95% confidence interval goes from
                  -0.3653547 to -0.2018772, which does not include 0.")
        ),
        h4("Conclusion"),
        p("Since the t statistic is > 1.96, the p-value is < 0.05, and the confidence
          interval does not include 0, we can reject the null hypothesis and be 95%
          confident that our -0.2856931 correlation is significantly different from
          zero. Greater human capital index in an African country tends to predict a
          lower exchange rate."),
        h4("Full Hypothesis Test Results"),
        textOutput("correlationtest")
      ),
      tabPanel(
        "Regression Model",
        h4("Which Model Did We Choose"),
        p("Because we are trying to predict exchange rate, a variable measured at
          the interval level, rather than a binary variable like growthbucket,
          we use a linear regression model."),
        h4("Our Linear Regression Model"),
        withMathJax("$$happiness_{i} = \\alpha +\\beta_1*human.capital.index_{i} 
                    + \\beta_2*emp.to.pop.ratio_{i} + \\beta_3*recession_{i} + \\epsilon_{i}$$"),
        h4("Coefficient Plot"),
        plotOutput("coefficientplot"),
        h4("Null Hypothesis"),
        p("For every coefficient we test the null hypothesis that the slope for a 
          particular control is equal to zero."),
        withMathJax("$$H_0: \\beta_i = 0$$"),
        h4("Alternative Hypothesis"),
        p("The alternative hypothesis is therefore that the slope is not equal to zero."),
        withMathJax("$$H_A: \\beta_i \\not = 0$$"),
        h4("Interpretation"),
        tags$ul(
          tags$li("Both Human Capital Index and Real Consumption of Households and Government
                  are statistically significant predictors of an African country's
                  exchange rate relative to the United States."),
          tags$li("All other control variables (In a Recession and Ratio of Employed Persons
                  to Population) are not statistically significant predictors at the
                  alpha = 0.05 level"),
          tags$li("Real Consumption of Households and Govt ($ Millions) [-5.8772e-04]: 
                  For every unit one increase (in this case every million increase in dollars) 
                  in real consumption of households and the government, we predict a -5.8772e-04
                  decrease in the exchange rate, all else equal."),
          tags$li("In a Recession [1.221e+02]: We predict an African country in a recession
                  to on average have an exchange rate which is 122.1 units greater
                  than an African country not in a recession, all else equal."),
          tags$li("Ratio of Employed Persons to Population [6.001e+02]: For every 
                  unit one increase in the ratio of employed persons to total population,
                  we predict a 600.05 increase in the exchange rate of an African country,
                  all else equal."),
          tags$li("Human Capital Index [-4.631e+02]: For every unit one increase
                  in the human capital index of an African country, we predict a
                  -463.09 decrease in the exchange rate, all else equal."),
          tags$li("Intercept [1.084e+03]: When all other control variables are set to
                  zero, we expect the exchange rate of an African country with a real consumption
                  of 0, not in a recession, with an employment ratio of 0 and a human capital
                  index of 0 to have an exchange rate of 1083.66")
        ),
        h4("Model Fit"),
        tags$ul(
          tags$li("Residual: On average the error in our predictions is approximately 760.4"),
          tags$li("Adjusted R-Squared: The explanatory variables in our model account for
                  9.03% of the variation in the exchange rate of African countries.")
        ),
        plotOutput("unique")
      ),
      tabPanel(
        "Interactive Prediction Plots",
        selectInput('x', 
                    'Explanatory Variable', 
                    c("hc", "ccon", "emp_to_pop_ratio")),
        plotOutput('plot')
      ),
      tabPanel(
        "Takeaways",
        h4("Many of the variables we ended up testing did not end up as statistically
           significant predictors of a nation's currency, and our model only accounted
           for less than 10% of the variation."),
        br(),
        h4("The data gap for this problem is huge and is likely a reason why modelling this
           situation is very difficult, in particular my data had a class imbalance."),
        br(),
        h4("When your data is sampled and designed to predict one variable, you are very
           likely to find bias when that data is used to predict a different variable."),
        br(),
        h4("Employment ratio was not a significant predictor of exchange rate, despite my initial
           cannon that it was all about employment rates and statistics."),
        br(),
        h4("I would like to explore this subject more and inspect and combine other datasets to find
           which variables best predict exchange rate.")
      )
    )
  )
)
