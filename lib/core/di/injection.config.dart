// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:e_contrat/features/assistant/data/datasources/assistant_local_datasource.dart'
    as _i615;
import 'package:e_contrat/features/assistant/data/datasources/assistant_remote_datasource.dart'
    as _i129;
import 'package:e_contrat/features/assistant/data/repositories/assistant_repository_impl.dart'
    as _i706;
import 'package:e_contrat/features/assistant/domain/repositories/assistant_repository.dart'
    as _i799;
import 'package:e_contrat/features/assistant/domain/usecases/assistant_usecases.dart'
    as _i139;
import 'package:e_contrat/features/contract/data/datasources/contract_templates_static_datasource.dart'
    as _i495;
import 'package:e_contrat/features/contract/data/repositories/contract_templates_repository_impl.dart'
    as _i606;
import 'package:e_contrat/features/contract/domain/repositories/contract_templates_repository.dart'
    as _i412;
import 'package:e_contrat/features/contract/domain/usecases/get_contract_categories.dart'
    as _i493;
import 'package:e_contrat/features/pdf_management/data/datasources/pdf_local_datasource.dart'
    as _i850;
import 'package:e_contrat/features/pdf_management/data/repositories/pdf_repository_impl.dart'
    as _i323;
import 'package:e_contrat/features/pdf_management/domain/repositories/pdf_repository.dart'
    as _i627;
import 'package:e_contrat/features/pdf_management/domain/usecases/delete_pdf.dart'
    as _i974;
import 'package:e_contrat/features/pdf_management/domain/usecases/get_all_pdfs.dart'
    as _i65;
import 'package:e_contrat/features/pdf_management/domain/usecases/save_pdf_bytes.dart'
    as _i234;
import 'package:e_contrat/features/pdf_management/presentation/bloc/pdf_list_bloc.dart'
    as _i713;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i495.ContractTemplatesStaticDataSource>(
      () => const _i495.ContractTemplatesStaticDataSource(),
    );
    gh.factory<_i850.PdfLocalDataSource>(() => _i850.PdfLocalDataSource());
    gh.lazySingleton<_i627.PdfRepository>(
      () => _i323.PdfRepositoryImpl(gh<_i850.PdfLocalDataSource>()),
    );
    gh.lazySingleton<_i412.ContractTemplatesRepository>(
      () => _i606.ContractTemplatesRepositoryImpl(
        gh<_i495.ContractTemplatesStaticDataSource>(),
      ),
    );
    gh.lazySingleton<_i615.AssistantLocalDataSource>(
      () => _i615.AssistantLocalDataSourceImpl(),
    );
    gh.factory<_i493.GetContractCategories>(
      () =>
          _i493.GetContractCategories(gh<_i412.ContractTemplatesRepository>()),
    );
    gh.lazySingleton<_i129.AssistantRemoteDataSource>(
      () => _i129.AssistantRemoteDataSourceImpl(),
    );
    gh.factory<_i974.DeletePdf>(
      () => _i974.DeletePdf(gh<_i627.PdfRepository>()),
    );
    gh.factory<_i65.GetAllPdfs>(
      () => _i65.GetAllPdfs(gh<_i627.PdfRepository>()),
    );
    gh.factory<_i234.SavePdfBytes>(
      () => _i234.SavePdfBytes(gh<_i627.PdfRepository>()),
    );
    gh.lazySingleton<_i799.AssistantRepository>(
      () => _i706.AssistantRepositoryImpl(
        localDataSource: gh<_i615.AssistantLocalDataSource>(),
        remoteDataSource: gh<_i129.AssistantRemoteDataSource>(),
      ),
    );
    gh.factory<_i713.PdfListBloc>(
      () => _i713.PdfListBloc(
        getAllPdfs: gh<_i65.GetAllPdfs>(),
        deletePdf: gh<_i974.DeletePdf>(),
      ),
    );
    gh.factory<_i139.GetConversations>(
      () => _i139.GetConversations(gh<_i799.AssistantRepository>()),
    );
    gh.factory<_i139.CreateConversation>(
      () => _i139.CreateConversation(gh<_i799.AssistantRepository>()),
    );
    gh.factory<_i139.DeleteConversation>(
      () => _i139.DeleteConversation(gh<_i799.AssistantRepository>()),
    );
    gh.factory<_i139.GetMessages>(
      () => _i139.GetMessages(gh<_i799.AssistantRepository>()),
    );
    gh.factory<_i139.SendMessage>(
      () => _i139.SendMessage(gh<_i799.AssistantRepository>()),
    );
    gh.factory<_i139.SaveMessage>(
      () => _i139.SaveMessage(gh<_i799.AssistantRepository>()),
    );
    gh.factory<_i139.UpdateConversationTitle>(
      () => _i139.UpdateConversationTitle(gh<_i799.AssistantRepository>()),
    );
    return this;
  }
}
