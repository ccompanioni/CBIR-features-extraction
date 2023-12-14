function [stdValues] = ExtractStdValuesFromFeatureDatabase(featureDatabase)

count = 1;
[rows cols] = size(featureDatabase);

for i = 1:rows
   count = 1;
   for j = 2:2:cols
       stdValues(i,count) = featureDatabase(i,j);
       count = count + 1;
   end
end