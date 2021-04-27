library(shiny)
library(ggplot2)
library(sjPlot)
library(stargazer)
library(tidyverse)
library(dplyr)
library(shinythemes)

function(input, output) {
  
  recession <- read.csv("data/africa_recession.csv")
  
  our.recession.model <- lm(xr ~ hc + emp_to_pop_ratio + factor(growthbucket) + ccon, data = recession)
  
  output$plot <- renderPlot({
    
    p <- plot_model(our.recession.model,
                    type = "pred",
                    terms = c(input$x, "growthbucket"),
                    show.data = FALSE,
                    title = "Predicted Exchange Rate of an African Country as a Function of Human Capital Index",
                    legend.title = "Recession") +
      scale_color_discrete(labels = c("No Recession", "Recession"))
    print(p)
    
  }, height=800)
  
  output$measurementxr <- renderPlot({
    p <- recession %>%
      ggplot(mapping = aes(x = xr)) + 
      geom_histogram(color = "darkgreen", bins = 100) +
      geom_vline(aes(xintercept = median(xr, na.rm = TRUE)), color = "purple", 
                 linetype = "dashed") + 
      annotate("text", x = 1200, y = 150, 
               label = paste0("Median = ", 
                              round(median(recession$xr, na.rm = TRUE), 4))) +
      labs(title = "The median exchange rate for the set of African countries is 152.0798",
           x = "Exchange Rate Relative to USD",
           y = "Frequency", 
           caption = "Source: African Country Recession Dataset")
    print(p)
  })
  
  output$measurementhc <- renderPlot({
    p <- recession %>%
      ggplot(mapping = aes(x = hc)) + 
      geom_histogram(color = "darkgreen", bins = 50) +
      geom_vline(aes(xintercept = median(hc, na.rm = TRUE)), color = "purple", 
                 linetype = "dashed") + 
      annotate("text", x = 2, y = 20, 
               label = paste0("Median = ", 
                              round(median(recession$hc, na.rm = TRUE), 4))) +
      labs(title = "The median human capital index for the set of African countries is 1.6899",
           x = "Human Capital Index",
           y = "Frequency", 
           caption = "Source: African Country Recession Dataset")
    print(p)
  })
  
  output$measurementrecession <- renderPlot({
    p <- recession %>%
      group_by(growthbucket) %>%
      summarise(freq = n()) %>%
      mutate(prop = freq / sum(freq)) %>%
      ggplot(data = recession, mapping = aes(x = factor(growthbucket))) +
      geom_bar(aes(y = ..prop.., group = 1), fill = "darkgreen") +
      labs(title = "The most common economic state of the African Countries We
Sampled Was Recession",
           x = "Level of Recession",
           y = "Proportion") +
      scale_x_discrete(labels = c("Not a Recession", "Recession"))
    print(p)
  })
  
  output$unique <- renderPlot({
    p <- plot_model(our.recession.model,
                    type = "pred",
                    terms = c("hc", "emp_to_pop_ratio"),
                    show.data = FALSE,
                    title = "Predicted Exchange Rate of an African Country as a Function
of Human Capital Index and Employment Ratio") +
      labs(caption = "Predictions are for countries with the mean real consumption
and the mean level of recession.")
    print(p)
  })
  
  output$bivariate <- renderPlot({
    
    p <- recession %>%
      filter(!is.na(hc), !is.na(xr)) %>%
      ggplot(mapping = aes(x = hc, y = xr)) +
      geom_point(color = "darkgreen") +
      geom_smooth(color = "purple", se = FALSE, method = "lm") +
      labs(title = "Human Capital Index and the Exchange Rate of African Countries",
           x = "Human Capital Index",
           y = "Exchange Rate",
           caption = "Source: ")
    
    print(p)
    
  }, height = 400)
  
  output$pearsoncoefficient <- renderText(
    cor(x = recession$hc, y = recession$xr, use = "pairwise.complete.obs", method = "pearson")
  )
  
  output$correlationtest <- renderPrint(
    cor.test(recession$xr, recession$hc, use = "pairwise.complete.obs")
  )
  
  output$coefficientplot <- renderPlot({
    p <- plot_model(our.recession.model,
               type = "est",
               show.values = TRUE, 
               value.offset = .3,
               show.intercept = TRUE,
               transform = NULL,
               title = "Linear Regression Model of the Exchange Rate of an African Country",
               axis.labels = c("Real Consumption of Households and Govt ($ Millions)",
                               "In a Recession",
                               "Ratio of Employed Persons to Total Population",
                               "Human Capital Index",
                               "Intercept"),
               dep.var.labels = "Exchange Rate of African Country")
    
    print(p)
  }, height = 400)
  
  output$hyperinflation <- renderUI({
    img(src='hyper.jpeg', height = '300px')
  })
  
}