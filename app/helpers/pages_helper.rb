module PagesHelper

  def use_cases
    # MOCKED
    [
      {
        :href  => '#use_cases#jornalismo_de_dados',
        :title => t('frontpage.what.journalism'),
        :image => 'imgs/journalism.png',
        :text  => t('frontpage.what.journalism_explanation'),
      },
      {
        :href  => '#use_cases#mapeamento_de_redes',
        :title => t('frontpage.what.network'),
        :image => 'imgs/network.png',
        :text  => t('frontpage.what.network_explanation'),
      },
      {
        :href  => '#use_cases#avaliacao_de_projetos_e_programas',
        :title => t('frontpage.what.evaluation'),
        :image => 'imgs/evaluation.png',
        :text  => t('frontpage.what.evaluation_explanation'),
      },
      {
        :href  => '#use_cases#diagnostico_de_territorio',
        :title => t('frontpage.what.diagnosis'),
        :image => 'imgs/diagnosis.png',
        :text  => t('frontpage.what.diagnosis_explanation'),
      },
      {
        :href  => '#use_cases#guia_do_bairro',
        :title => t('frontpage.what.guide'),
        :image => 'imgs/guide.png',
        :text  => t('frontpage.what.guide_explanation'),
      },
    ]
  end

  def testimonials
    # MOCKED
    [
      {
        :name         => 'aldeias-infantis',
        :href         => 'http://maps.mootiro.org/project/17',
        :image        => 'imgs/aldeias-infantis.png',
        :text         => "O MootiroMaps permite não apenas vizualizar o local onde está o possível parceiro, mas também obter informações sobre seus serviços e esfera de atuação. Para as Aldeias Infantis SOS, a ferramenta é um potencial para a identificação do nível de articulação desenvolvido.",
        :author_href  => 'http://maps.mootiro.org/user/259',
        :author_name  => 'Aline Cavalcanti',
        :author_title => 'Analista de Monitoramento e<br/> Pesquisa das <a href="http://maps.mootiro.org/organization/2134">Aldeias Infantis SOS</a>'
      },
      {
        :name         => 'heliopolis-verde',
        :href         => 'http://maps.mootiro.org/project/2',
        :image        => 'imgs/heliopolis-verde.png',
        :text         => "O primeiro passo de um projeto social de base comunitária é a realização de um mapa de contexto, a fim de identificar demandas e conhecer os atores locais. A visualização das informações e a possibilidade de mapear coletivamente com o MootiroMaps favorecem e facilitam nosso trabalho com o Heliópolis Verde.",
        :author_href  => 'http://maps.mootiro.org/user/101',
        :author_name  => 'Raquel Porangaba',
        :author_title => 'Analista de articulação <br/> do <a href="http://maps.mootiro.org/organization/793">Instituto Baccarelli</a>'
      },
      {
        :name         => 'bairro-educador',
        :href         => 'http://maps.mootiro.org/project/22',
        :image        => 'imgs/bairro-educador.png',
        :text         => 'É importante criarmos o mapa de nossa comunidade porque é possível quantificar no MootiroMaps a necessidade da comunidade em relação às políticas públicas bem como acompanhar os serviços públicos e as obras que acontecem em Heliópolis.',
        :author_href  => '#',
        :author_name  => 'Cleide Alves',
        :author_title => 'Presidente da <a href="http://maps.mootiro.org/organization/796">UNAS</a>'
      },
      {
        :name         => 'educar-na-cidade',
        :href         => 'http://maps.mootiro.org/project/13',
        :image        => 'imgs/educar-na-cidade.jpg',
        :text         => "Mapeamos equipamentos sociais e iniciativas educativas para estimular a interação entre pessoas e organizações possibilitando assim a troca de experiências e conexões que fortaleçam vínculos entre esses agentes para o trabalho em rede e desenvolvimento local.",
        :author_href  => 'http://maps.mootiro.org/user/237',
        :author_name  => 'Maria Rita Ecosteguy',
        :author_title => 'analista do <a href="http://maps.mootiro.org/organization/25">CENPEC</a>'
      },
    ]
  end

  def featured_maps
    # MOCKED
    [
      {
        :url  => '#',
        :title => 'Featured Map',
        :image => '',
        :excerpt  => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor',
      },
      {
        :url  => '#',
        :title => 'Featured Map',
        :image => '',
        :excerpt  => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor',
      },
      {
        :url  => '#',
        :title => 'Featured Map',
        :image => '',
        :excerpt  => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor',
      },
    ]
  end

end
