nominal <- function(x) {
    factor(x,
           levels = 1:3,
           labels = c('Yes', 'No', 'Unknown'))
}
