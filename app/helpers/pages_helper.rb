module PagesHelper

  def use_cases
    [
      {
        :href  => '#use_cases#diagnostico_de_territorio',
        :title => t('frontpage.what.diagnosis'),
        :image => 'imgs/diagnosis.png',
        :text  => t('frontpage.what.diagnosis_explanation'),
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
        :href  => '#use_cases#jornalismo_de_dados',
        :title => t('frontpage.what.journalism'),
        :image => 'imgs/journalism.png',
        :text  => t('frontpage.what.journalism_explanation'),
      },
      {
        :href  => '#use_cases#guia_do_bairro',
        :title => t('frontpage.what.guide'),
        :image => 'imgs/guide.png',
        :text  => t('frontpage.what.guide_explanation'),
      },
    ]
  end
end
