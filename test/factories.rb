Factory.define :tache do |tache|
  tache.description "tache"
end

Factory.define :tag do |tag|
  tag.description "tag"
end

Factory.define :etiquetage do |etiquetage|
  etiquetage.association :tag
  etiquetage.association :tache
end