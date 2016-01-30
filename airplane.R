# script to read in and clean up screenplay for Airplane!(1980)

ap <- readLines("http://www.awesomefilm.com/script/airplane.txt")

# trim the top and bottom
ap <- ap[-1:-5]
ap <- ap[-(length(ap)-4):-length(ap)]

# remove scene descriptions: text between parantheses
library(qdapRegex)
ap <- rm_between(ap, "(", ")")
# remove blank elements left over from previous call
ap <- ap[which(sapply(ap, nchar)>0)]


# wrap lines so every line beings with "CHARACTER :"
colon <- grepl(":[^0-9]", ap) # is colon in line (not counting references to time)?
j <- 0 # counter for lines
tmp <- character(length = length(ap)) # preallocate space (overestimate)
for(i in seq_along(colon)){
  if(colon[i]) {
    j <- j + 1
    tmp[j] <- ap[i]
  } else {
    tmp[j] <- paste(tmp[j],ap[i],collapse = " ")
  }
}

# clean up blank lines at end
ap <- tmp[which(sapply(tmp, nchar)>0)]

# clean up
rm(colon, i, j, tmp)

# again remove the scene explanations: between ()
ap <- rm_between(ap, "(", ")")
# remove blank elements left over from previous call


# some manual clean up
ap[grep("GOLLY\\.", ap)] <- "Subtitle: GOLLY"
ap[grep(": Re-quest Vector, over!", ap)] <- "Tower : Request Vector, over!"


# copy to clipboard so you can paste into Notepad and review progress
# writeClipboard(ap)

save(ap, file = "airplane.Rda")

