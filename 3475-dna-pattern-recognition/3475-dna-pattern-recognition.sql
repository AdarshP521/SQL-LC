select * , if(dna_sequence regexp '^ATG',1,0) as has_start,
        if(dna_sequence regexp '(TAA|TAG|TGA)$',1,0) as has_stop,
        if(dna_sequence regexp 'ATAT',1,0) as has_atat,
        if(dna_sequence regexp 'GGG',1,0) as has_ggg
from Samples
order by sample_id;