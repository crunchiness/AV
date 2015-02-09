function [ centers, radii ] = find_overlap( centers,radii,gamma)
%FIND_OVERLAP Summary of this function goes here
%   Detailed explanation goes here

for i=1:size(radii)
    for j=1:i-1
      if(radii(i)~=0 && radii(j)~=0)
          if((gamma/2)*(radii(i)+radii(j)) > norm(centers(i,:)-centers(j,:)))

                radii(i)=0.5*radii(i)+0.5*radii(j);
                centers(i,:)=0.5*centers(i,:)+0.5*centers(j,:);

                radii(j)=0;
                centers(j,:)=0;
          end
      end
    end               
end

for i=size(radii):-1:1
     
    if(radii(i)==0)
       radii(i)=[];
       centers(i,:)=[];
        
    end
end


end

