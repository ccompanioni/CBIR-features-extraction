function [meanValues] = ExtractMeanValuesFromFeatureDatabase(featureDatabase)

count = 1;
[rows cols] = size(featureDatabase);

for i = 1:rows
   count = 1;
   for j = 1:2:cols
       meanValues(i,count) = featureDatabase(i,j);
       count = count + 1;
   end
end